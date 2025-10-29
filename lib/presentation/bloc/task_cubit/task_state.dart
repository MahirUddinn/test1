part of 'task_cubit.dart';

enum TaskStatus { loading, loaded, error }

class TaskState {
  final TaskStatus status;
  final List<TaskModel> tasks;
  final String? errorMessage;

  const TaskState({
    this.status = TaskStatus.loading,
    this.tasks = const [],
    this.errorMessage,
  });

  TaskState copyWith({
    TaskStatus? status,
    List<TaskModel>? tasks,
    String? errorMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}