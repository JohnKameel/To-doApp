import 'package:todo/data/models/tasks.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(Task task);
  Future<List<Task>> getAllTasks();
  Future<List<Task>> getTasksForDate(DateTime date);
}