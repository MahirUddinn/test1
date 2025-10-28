import 'package:flutter/material.dart';
import 'package:test1/models/todo_model.dart';
import 'package:intl/intl.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.todo});
  final TodoModel todo;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final formatter = DateFormat.yMd();
  final _textController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  void _submit() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("You must have a title at least")));
      return;
    }
    final todo = TodoModel(
      id: widget.todo.id,
      title: _textController.text,
      description: _descriptionController.text,
      date: _selectedDate != null ? formatter.format(_selectedDate!) : widget.todo.date,
      checkBox: widget.todo.checkBox,
    );
    Navigator.of(context).pop(todo);
  }

  void _presentDayPicker() async {
    final now = DateTime.now();
    final isDate = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: now,
    );
    setState(() {
      _selectedDate = isDate;
    });
  }

  @override
  void initState() {
    super.initState();
    _textController.text = widget.todo.title;
    _descriptionController.text = widget.todo.description;
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Task")),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _textController,
                maxLength: 50,
                decoration: const InputDecoration(label: Text("Title")),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return "ToDo should between 1 and 50 characters";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                maxLength: 100,
                decoration: const InputDecoration(label: Text("Description")),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 100) {
                    return "Description should between 1 and 100 characters";
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.todo.date == ""
                          ? Text("Select a Date")
                          : Text(widget.todo.date),

                      IconButton(
                        onPressed: _presentDayPicker,
                        icon: Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.tertiaryContainer,
                    ),
                    child: Text("Update"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
