import 'package:flutter/material.dart';
import 'package:test1/models/task_model.dart';
import 'package:test1/models/todo_model.dart';
import 'package:uuid/uuid.dart';

class TaskAddScreen extends StatefulWidget {
  const TaskAddScreen({super.key, required this.todo});

  final TodoModel todo;

  @override
  State<TaskAddScreen> createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  final _textController = TextEditingController();

  void submit() {
    if (_textController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("You must have a title at least"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Okay"),
              ),
            ],
          );
        },
      );
      return;
    }
    final task = TaskModel(
      id: Uuid().v4(),
      todoId: widget.todo.id,
      title: _textController.text,
      checkBox: false,
    );
    Navigator.of(context).pop(task);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(

      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _textController,
                  maxLength: 50,
                  decoration: const InputDecoration(label: Text("Title")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: submit, child: Text("Add")),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
