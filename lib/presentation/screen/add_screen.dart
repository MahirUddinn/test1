import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test1/models/todo_model.dart';
import 'package:test1/presentation/bloc/todo_cubit.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final formatter = DateFormat.yMd();
  final _textController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  void _submit() {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("You must have a title at least")));
      return;
    } else {
      final todo = TodoModel(
        id: uuid.v4(),
        title: _textController.text,
        description: _descriptionController.text.isEmpty
            ? ""
            : _descriptionController.text,
        date: _selectedDate == null
            ? ""
            : _selectedDate.toString().substring(0, 10),
        checkBox: false,
      );

      context.read<TodoCubit>().addTodos(todo);
      Navigator.of(context).pop();
    }
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
  void dispose() {
    super.dispose();
    _textController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
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
                      (_selectedDate == null)
                          ? Text("Select a Date")
                          : Text(formatter.format(_selectedDate!)),
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
                    child: Text("Submit"),
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
