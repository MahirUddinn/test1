import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/models/task_model.dart';
import 'package:test1/models/todo_model.dart';
import 'package:test1/presentation/bloc/task_cubit/task_cubit.dart';
import 'package:test1/presentation/screen/task_add_screen.dart';
import 'package:test1/presentation/screen/task_edit_screen.dart';
import 'package:test1/presentation/widget/task_item.dart';

class DetailedScreen extends StatefulWidget {
  const DetailedScreen({
    super.key,
    required this.todo,
    required this.onTodoCheck,
  });

  final TodoModel todo;
  final VoidCallback onTodoCheck;

  @override
  State<DetailedScreen> createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen> {
  void openBottomModal() async {
    final task = await showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        widget.onTodoCheck;
        return TaskAddScreen(todo: widget.todo);
      },
    );

    if (task != null) {
      widget.onTodoCheck;
      context.read<TaskCubit>().addTasks(task);
    }
  }
  
  void openEditScreen(TaskModel editTask)async{
    final task = await showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        widget.onTodoCheck;
        return TaskEditScreen(task: editTask);
      },
    );

    if (task != null) {
      widget.onTodoCheck;
      context.read<TaskCubit>().updateTask(task);
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().loadTasks(widget.todo);
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;

    return Scaffold(
      appBar: AppBar(title: Text(todo.title)),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        onPressed: () {
          openBottomModal();
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildDescription(todo),
          SizedBox(height: 10),
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              if (state.status == TaskStatus.loading && state.tasks.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == TaskStatus.error) {
                return Center(child: Text(state.errorMessage!));
              }
              return Expanded(child: _buildTaskList(state.tasks));
            },
          ),
        ],
      ),
    );
  }

  _buildTaskList(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return const Center(child: Text("No tasks yet"));
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskItem(
          task: tasks[index],
          onCheck: () {
            context.read<TaskCubit>().updateTask(
              TaskModel(
                id: tasks[index].id,
                todoId: tasks[index].todoId,
                title: tasks[index].title,
                description: tasks[index].description,
                checkBox: !tasks[index].checkBox,
              ),
            );
            widget.onTodoCheck();
          },
          onEdit: () {
            openEditScreen(tasks[index]);
          },
        );
      },
    );
  }

  _buildDescription(TodoModel todo) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text(
          todo.description.isEmpty
              ? "No description was added for this todo"
              : todo.description,
        ),
      ),
    );
  }
}
