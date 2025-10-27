import 'package:flutter/material.dart';
import 'package:test1/models/todo_model.dart';

class TodoItem extends StatelessWidget {
  final TodoModel item;

  const TodoItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text(item.date),
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  IconButton(
                    onPressed: () {},
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
    );
  }
}
