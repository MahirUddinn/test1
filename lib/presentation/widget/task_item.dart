import 'package:flutter/material.dart';
import 'package:test1/models/task_model.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task, required this.onCheck});

  final VoidCallback onCheck;
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
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
              children: [
                Text(task.title),
                Text(task.description)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
