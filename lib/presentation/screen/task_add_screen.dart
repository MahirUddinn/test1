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
  final _descriptionController = TextEditingController();

  void submit() {
    final task = TaskModel(
      id: Uuid().v4(),
      todoId: widget.todo.id,
      title: _textController.text,
      description: _descriptionController.text,
      checkBox: false,
    );
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
          padding: EdgeInsets.all(16),
          child: Column(
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
                  ElevatedButton(onPressed: submit, child: Text("Add")),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
