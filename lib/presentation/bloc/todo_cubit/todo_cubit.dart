import 'package:bloc/bloc.dart';
import 'package:test1/data/database_helper.dart';
import 'package:test1/models/todo_model.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final AppDatabase databaseHelper;

  TodoCubit(this.databaseHelper) : super(TodoState());

  bool showChecked = true;
  final int _listSize = 15;
  int _currentList = 0;

  void loadNextPage() {
    loadPaginatedTodos(_listSize, _currentList);
    _currentList++;
  }

  void loadPaginatedTodos(int limit, int offset) async {
    if (offset == 0) {
      emit(state.copyWith(status: TodoStatus.loading));
    }
    try {
      final newTodos = await databaseHelper.getPaginatedTodos(
        limit,
        limit * offset,
      );
      final updatedTodos = List<TodoModel>.from(state.todos)..addAll(newTodos);
      emit(state.copyWith(status: TodoStatus.loaded, todos: updatedTodos));
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
          errorMessage: "Failed to load paginated todo: $e",
        ),
      );
    }
  }

  void resetPagination() {
    _currentList = 0;
    emit(state.copyWith(todos: []));
    loadNextPage();
  }

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
          todos: [todo, ...state.todos],
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

  void updateTodo(TodoModel todo) async {
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

  void filteredTodos() async {
    emit(state.copyWith(status: TodoStatus.loading));

    try {
      final todos = await databaseHelper.getTodos();
      final uncheckedTodos = todos.where((todo) => !todo.checkBox).toList();
      final checkedTodos = todos.where((todo) => todo.checkBox).toList();

      final filteredList = showChecked ? checkedTodos : uncheckedTodos;

      emit(state.copyWith(todos: filteredList, status: TodoStatus.loaded));
      showChecked = !showChecked;
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
          errorMessage: "Failed to filter todos: $e",
        ),
      );
    }
  }
}
