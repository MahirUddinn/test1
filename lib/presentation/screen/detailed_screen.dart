import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/data/temp.dart';
import 'package:test1/models/task_model.dart';
import 'package:test1/models/todo_model.dart';
import 'package:test1/presentation/bloc/task_cubit/task_cubit.dart';
import 'package:test1/presentation/screen/task_add_screen.dart';
import 'package:test1/presentation/widget/task_item.dart';

class DetailedScreen extends StatefulWidget {
  const DetailedScreen({super.key, required this.todo});

  final TodoModel todo;

  @override
  State<DetailedScreen> createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen> {
  void openBottomModal() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (ctx) => TaskAddScreen(todo: widget.todo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;

    return Scaffold(
      appBar: AppBar(title: Text(todo.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openBottomModal();
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildDescription(todo),
          SizedBox(height: 10),
          Expanded(child: _buildTaskList(dummyTasks)),
        ],
      ),
    );
  }

  _buildTaskList(List<TaskModel> tasks) {
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
