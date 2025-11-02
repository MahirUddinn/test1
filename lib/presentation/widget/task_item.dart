import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/models/task_model.dart';
import 'package:test1/presentation/bloc/task_cubit/task_cubit.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: ValueKey(task.id),
      onDismissed: (direction) {
        context.read<TaskCubit>().deleteTasks(task.id);
      },
      background: Container(
        color: colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(Icons.delete, color: colorScheme.onError),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        color: task.checkBox
            ? colorScheme.surfaceContainerHigh
            : colorScheme.tertiaryContainer,
        elevation: task.checkBox ? 0 : 1,
        child: ListTile(
          leading: IconButton(
            icon: Icon(
              task.checkBox ? Icons.check_box : Icons.check_box_outline_blank,
              color: task.checkBox
                  ? Colors.blueAccent
                  : colorScheme.onSurfaceVariant,
            ),
            onPressed: onCheck,
          ),
          title: Text(
            task.title,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: task.checkBox ? TextDecoration.lineThrough : null,
              color: task.checkBox
                  ? theme.textTheme.bodySmall?.color
                  : theme.textTheme.bodyLarge?.color,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit, color: colorScheme.secondary),
            onPressed: onEdit,
          ),
        ),
      ),
    );
  }
}
