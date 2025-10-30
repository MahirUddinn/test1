import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/models/task_model.dart';
import 'package:test1/presentation/bloc/task_cubit/task_cubit.dart';
import 'package:test1/presentation/screen/task_add_screen.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.onCheck,
    required this.onEdit,
  });

  final VoidCallback onCheck;
  final TaskModel task;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      onDismissed: (direction) {
        context.read<TaskCubit>().deleteTasks(task.id);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: task.checkBox ? Color(0xFF81C784) : Color(0xFFB0BEC5),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onCheck,
              icon: Icon(
                task.checkBox ? Icons.check_box : Icons.check_box_outline_blank,
                size: 30,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(task.title), Text(task.description)],
              ),
            ),
            IconButton(onPressed: onEdit, icon: Icon(Icons.edit)),
          ],
        ),
      ),
    );
  }
}
