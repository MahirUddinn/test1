import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/models/todo_model.dart';
import 'package:test1/presentation/bloc/todo_cubit/todo_cubit.dart';

class TodoItem extends StatelessWidget {
  final TodoModel item;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTap;

  const TodoItem({super.key, required this.item, this.onTapEdit, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final textDecoration = item.checkBox ? TextDecoration.lineThrough : null;
    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      decoration: textDecoration,
    );
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.textTheme.bodySmall?.color,
      decoration: textDecoration,
    );

    return Dismissible(
      onDismissed: (direction) {
        context.read<TodoCubit>().deleteTodos(item.id);
      },
      background: Container(
        color: colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(Icons.delete, color: colorScheme.onError),
      ),
      key: ValueKey(item.id),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        color: item.checkBox
            ? colorScheme.surfaceContainerHigh
            : Colors.white,
        elevation: item.checkBox ? 0 : 1,
        child: ListTile(
          selectedColor: theme.colorScheme.tertiaryContainer,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          onTap: onTap,
          title: Text(item.title, style: titleStyle),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: subtitleStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (item.date.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(item.date, style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit, color: colorScheme.primary),
            onPressed: onTapEdit,
          ),
        ),
      ),
    );
  }
}
