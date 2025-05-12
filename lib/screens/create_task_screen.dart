import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todo/config/routes/router_location.dart';
import 'package:todo/data/data.dart';
import 'package:todo/provider/date_provider.dart';
import 'package:todo/provider/providers.dart';
import 'package:todo/utils/app.alerts.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/utils/helpers.dart';
import 'package:todo/widgets/common_text_field.dart';
import 'package:todo/widgets/display_while_text.dart';
import 'package:todo/widgets/select_date_time.dart';
import '../provider/category_provider.dart';
import '../provider/time_provider.dart';
import '../utils/notification_services.dart';
import '../widgets/select_category.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  static CreateTaskScreen builder(BuildContext context, GoRouterState state) => const CreateTaskScreen();
  const CreateTaskScreen({super.key});

  @override
  ConsumerState<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final NotificationService _notificationService = NotificationService();
  DateTime selectedDate = DateTime.now();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationService.initialize();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const DisplayWhileText(text: 'Add New Task'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonTextField(
                title: 'Task Title',
                hintText: 'Task Title',
                controller: _titleController,
              ),
              const Gap(16),
              const SelectCategory(),
              const Gap(16),
              const SelectDateTime(),
              const Gap(16),
              CommonTextField(
                title: 'Note',
                hintText: 'Task Note here',
                maxLines: 6,
                controller: _noteController,
              ),
              const Gap(60),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(colors.primary),
                ),
                onPressed: _createTask,
                child: const DisplayWhileText(text: 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _createTask() async {
    final title = _titleController.text.trim();
    final note = _noteController.text.trim();
    final date = ref.watch(dateProvider);
    final time = ref.watch(timeProvider);
    final category = ref.watch(categoryProvider);

    // Ensure title is not empty
    if (title.isEmpty) {
      AppAlerts.displaySnackBar(context, 'Task title cannot be empty');
      return;
    }

    // Create the task object
    final task = Task(
      title: title,
      note: note,
      time: Helpers.timeToString(time),
      date: DateFormat.yMMMd().format(date),
      category: category,
      isCompleted: false,
    );

    // Create the task in the database
    await ref.read(taskProvider.notifier).createTask(task);

    // Combine date and time into one DateTime object
    final scheduledDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Ensure the scheduled date is in the future
    if (scheduledDateTime.isBefore(DateTime.now())) {
      AppAlerts.displaySnackBar(context, 'Please select a future date and time');
      return;
    }

    final tasksForDate = await ref.read(taskProvider.notifier).getTasksForDate(date);

    // If there are tasks already scheduled for the selected date, schedule a daily morning reminder
    if (tasksForDate.isNotEmpty) {
      final taskTitles = tasksForDate.map((t) => '• ${t.title}').join('\n');
      await _notificationService.scheduleDailyMorningTaskReminder(
        body: 'You have ${tasksForDate.length} task(s) today:\n$taskTitles',
      );
    }


    // Schedule the notification
    await _notificationService.scheduleNotification(
      scheduledDateTime,
      title: 'Reminder: $title',
      body: note.isNotEmpty ? note : 'You have a task scheduled.',
    );

    // Display success message and navigate back to home
    AppAlerts.displaySnackBar(context, 'Task created and notification scheduled');
    context.go(RouterLocation.home);
  }
}