import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/provider/task/task_notifier.dart';
import 'package:todo/provider/task/task_state.dart';
import '../../data/repositories/task_repository_provider.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});