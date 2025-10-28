part of 'todo_cubit.dart';

enum TodoStatus { loading, loaded, error }

class TodoState {
  final TodoStatus status;
  final List<TodoModel> todos;
  final String? errorMessage;

  const TodoState({
    this.status = TodoStatus.loading,
    this.todos = const [],
    this.errorMessage,
  });

  TodoState copyWith({
    TodoStatus? status,
    List<TodoModel>? todos,
    String? errorMessage,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}