import 'package:bloc/bloc.dart';
import 'package:test1/data/database_helper.dart';
import 'package:test1/models/todo_model.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final AppDatabase databaseHelper;

  TodoCubit(this.databaseHelper) : super(TodoState());

  void loadTodos() async {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      final todos = await databaseHelper.getTodos();
      emit(state.copyWith(status: TodoStatus.loaded, todos: todos));
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
          errorMessage: "Failed to load todo: $e",
        ),
      );
    }
  }

  void addTodos(TodoModel todo) async {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      await databaseHelper.addTodo(todo);
      emit(
        state.copyWith(
          status: TodoStatus.loaded,
          todos: [...state.todos, todo],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
          errorMessage: "Failed to add todo: $e",
        ),
      );
    }
  }

  void deleteTodos(String id) async {
    try {
      await databaseHelper.deleteTodos(id);
      loadTodos();
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
          errorMessage: "Failed to delete todo: $e",
        ),
      );
    }
  }

  void updateNote(TodoModel todo) async {
    try {
      int updatedId = await databaseHelper.updateTodos(todo);
      if (updatedId != 0) {
        final updatedTodos = state.todos.map((n) {
          return n.id == todo.id ? todo : n;
        }).toList();
        emit(state.copyWith(todos: updatedTodos));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
          errorMessage: "Failed to update todo: $e",
        ),
      );
    }
  }

  void sortedTodos(bool ascending) {
    emit(state.copyWith(status: TodoStatus.loading));

    try {
      final uncheckedTodos = state.todos
          .where((todo) => !todo.checkBox)
          .toList();
      final checkedTodos = state.todos.where((todo) => todo.checkBox).toList();

      final combinedList = ascending
          ? [...checkedTodos, ...uncheckedTodos]
          : [...uncheckedTodos, ...checkedTodos];

      emit(state.copyWith(todos: combinedList, status: TodoStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
          errorMessage: "Failed to sort todos: $e",
        ),
      );
    }
  }
}
