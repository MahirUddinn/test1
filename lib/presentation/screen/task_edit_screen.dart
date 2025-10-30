import 'package:flutter/material.dart';
import 'package:test1/models/task_model.dart';
import 'package:uuid/uuid.dart';

class TaskEditScreen extends StatefulWidget {
  const TaskEditScreen({super.key, required this.task});
  final TaskModel task;
  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _textController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
  }

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
      id: widget.task.id,
      todoId: widget.task.todoId,
      title: _textController.text,
      description: _descriptionController.text,
      checkBox: widget.task.checkBox,
    );
    Navigator.of(context).pop(task);
  }

  @override
  void dispose() {
    _textController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _textController,
                maxLength: 50,
                decoration: const InputDecoration(label: Text("Title")),
              ),
              TextFormField(
                controller: _descriptionController,
                maxLength: 100,
                decoration: const InputDecoration(label: Text("Description")),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: submit, child: Text("Edit")),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
