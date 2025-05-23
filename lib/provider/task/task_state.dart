import 'package:equatable/equatable.dart';
import 'package:todo/data/models/tasks.dart';

class TaskState extends Equatable{
  final List<Task> tasks;

  const TaskState(this.tasks);
  const TaskState.initial({this.tasks = const []});

  TaskState copyWith({
    List<Task>? tasks,
}) {
    return TaskState(
        tasks ?? this.tasks,
    );
  }

  @override
  List<Object> get props => [tasks];
}