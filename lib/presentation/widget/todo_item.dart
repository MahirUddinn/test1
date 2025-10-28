import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/models/todo_model.dart';
import 'package:test1/presentation/bloc/todo_cubit.dart';

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
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      key: ValueKey(item.id),
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: item.checkBox ? Color(0xFF81C784) : Color(0xFFB0BEC5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                item.description == ""
                    ? SizedBox()
                    : SizedBox(
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
