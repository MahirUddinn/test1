import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/models/todo_model.dart';
import 'package:test1/presentation/bloc/todo_cubit.dart';
import 'package:test1/presentation/screen/edit_screen.dart';

class TodoItem extends StatelessWidget {
  final TodoModel item;
  final VoidCallback? onTapEdit;

  final VoidCallback? onTapCheck;

  const TodoItem({
    super.key,
    required this.item,
    this.onTapEdit,
    this.onTapCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        context.read<TodoCubit>().deleteTodos(item.id);
      },
      key: ValueKey(item.id),
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title),
                SizedBox(
                  width: 250,
                  child: Text(
                    item.description,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                item.date == "" ? SizedBox() : Text(item.date),
                Row(
                  children: [
                    IconButton(onPressed: onTapEdit, icon: Icon(Icons.edit)),
                    IconButton(
                      onPressed: () {
                        final todo = TodoModel(
                          id: item.id,
                          title: item.title,
                          description: item.description,
                          date: item.date,
                          checkBox: !item.checkBox,
                        );
                        context.read<TodoCubit>().updateNote(todo);
                      },
                      icon: item.checkBox
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
