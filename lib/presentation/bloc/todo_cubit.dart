import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
      final id = await databaseHelper.addTodo(todo);
      final newTodo = todo.copyWith(id: id.toString());
      emit(
        state.copyWith(
          status: TodoStatus.loaded,
          todos: [newTodo, ...state.todos],
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
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
          errorMessage: "Failed to add todo: $e",
        ),
      );
    }
  }

  void updateNote(TodoModel todo) async {
    // emit(state.copyWith(status: TodoStatus.loading));
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

  // void sortedTodos()async {
  //   emit(state.copyWith(status: TodoStatus.loading));
  //   try{
  //     List<TodoModel> uncheckedTodos = [];
  //     List<TodoModel> checkedTodos = [];
  //     for (var element in state.todos) {
  //       if(element.checkBox){
  //         uncheckedTodos.add(element);
  //       }
  //       else{
  //         checkedTodos.add(element);
  //       }
  //     }
  //     List<TodoModel> combinedList = [...uncheckedTodos, ...checkedTodos];
  //     state.copyWith(todos: combinedList, status: TodoStatus.loaded);
  //   }catch(e){
  //     emit(
  //       state.copyWith(
  //         status: TodoStatus.error,
  //         errorMessage: "Failed to sort todo: $e",
  //       ),
  //     );
  //   }
  //
  // }
}
