import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:test1/models/task_model.dart';
import 'package:test1/data/database_helper.dart';
import 'package:test1/models/todo_model.dart';
import 'package:test1/presentation/bloc/todo_cubit/todo_cubit.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final AppDatabase databaseHelper;

  TaskCubit(this.databaseHelper) : super(TaskState());

  void loadTasks(TodoModel todo) async {
    emit(state.copyWith(tasks: [], status: TaskStatus.loading));
    try {
      final tasks = await databaseHelper.getTask(todo);
      emit(state.copyWith(status: TaskStatus.loaded, tasks: tasks));
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStatus.error,
          errorMessage: "Failed to load task: $e",
        ),
      );
    }
  }

  void addTasks(TaskModel task) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      await databaseHelper.addTask(task);
      emit(
        state.copyWith(
          status: TaskStatus.loaded,
          tasks: [task, ...state.tasks],
          tasksFinished: false
        ),
      );

      final parentTodo = await databaseHelper.getTodoById(task.todoId);
      if (parentTodo != null && parentTodo.checkBox != state.tasksFinished) {
        final updatedTodo = parentTodo.copyWith(checkBox: state.tasksFinished);
        await databaseHelper.updateTodos(updatedTodo);
      }

    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStatus.error,
          errorMessage: "Failed to add task: $e",
        ),
      );
    }
  }

  void deleteTasks(String id) async {
    try {
      await databaseHelper.deleteTasks(id);
      final updatedTasks = state.tasks.where((task) => task.id != id).toList();
      emit(state.copyWith(status: TaskStatus.loaded, tasks: updatedTasks));
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStatus.error,
          errorMessage: "Failed to delete task: $e",
        ),
      );
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      final updatedId = await databaseHelper.updateTasks(task);

      if (updatedId != 0) {
        final updatedTasks = state.tasks.map((n) {
          return n.id == task.id ? task : n;
        }).toList();

        final allChecked =
            updatedTasks.isNotEmpty &&
            updatedTasks.every((t) => t.checkBox == true);

        emit(
          state.copyWith(
            tasks: updatedTasks,
            status: TaskStatus.loaded,
            tasksFinished: allChecked,
          ),
        );


        final parentTodo = await databaseHelper.getTodoById(task.todoId);
        if (parentTodo != null && parentTodo.checkBox != allChecked) {
          final updatedTodo = parentTodo.copyWith(checkBox: allChecked);
          await databaseHelper.updateTodos(updatedTodo);
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStatus.error,
          errorMessage: "Failed to update task: $e",
        ),
      );
    }
  }
}
