import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/data.dart';
import 'package:todo/provider/providers.dart';
import 'package:todo/utils/app.alerts.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/widgets/widgets.dart';

class DisplayListOfTasks extends ConsumerWidget {
  const DisplayListOfTasks({
    super.key,
    required this.tasks,
    this.isCompletedTasks = false,
  });
  final List<Task> tasks;
  final bool isCompletedTasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceSize = context.deviceSize;
    final height = isCompletedTasks? deviceSize.height * 0.25 : deviceSize.height * 0.3;
    final emptyTaskMessage = isCompletedTasks
        ? 'There is no Completed Task yet'
        : 'There is no Task todo!';
    return CommonContainer(
      height: height,
      child: tasks.isEmpty ?
          Center(
            child: Text(
              emptyTaskMessage,
              style: context.textTheme.headlineSmall,
            ),
          )
          :
          ListView.separated(
            shrinkWrap: true,
            itemCount: tasks.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return InkWell(
                onLongPress: () {
                  // Delete Task
                  AppAlerts.showDeleteAlertDialog(context, ref, task);
                },
                onTap: () async{
                  // Show Task Details
                  await showModalBottomSheet(context: context, builder: (context) {
                    return TaskDetails(task : task);
                  },);
                },
                  child: TaskTile(
                      task : task,
                    onCompleted: (value) async {
                      await ref.read(taskProvider.notifier).updateTask(task).then((value) {
                        AppAlerts.displaySnackBar(
                          context,
                          task.isCompleted ? 'Task incompleted' : 'Task completed',
                        );
                      },);
                    },
                  ),
              );
            }, separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                thickness: 1.5,
              );
          },
          ),
    );
  }
}
