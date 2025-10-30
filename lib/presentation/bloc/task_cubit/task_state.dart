part of 'task_cubit.dart';

enum TaskStatus { loading, loaded, error }

class TaskState {
  final TaskStatus status;
  final List<TaskModel> tasks;
  final String? errorMessage;
  final bool tasksFinished;

  const TaskState({
    this.status = TaskStatus.loading,
    this.tasks = const [],
    this.errorMessage,
    this.tasksFinished = false
  });

  TaskState copyWith({
    TaskStatus? status,
    List<TaskModel>? tasks,
    String? errorMessage,
    bool? tasksFinished
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage ?? this.errorMessage,
      tasksFinished: tasksFinished ?? this.tasksFinished
    );
  }
}