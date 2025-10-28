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
      id: uuid.v4(),
      title: _textController.text,
      description: _descriptionController.text,
      date: _selectedDate != null ? formatter.format(_selectedDate!) : "",
      checkBox: false,
    );

    context.read<TodoCubit>().addTodos(todo);
    Navigator.of(context).pop();
  }

  void _presentDayPicker() async {
    final now = DateTime.now();
    final isDate = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: DateTime(now.year + 1, now.month, now.day),
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
    );
  }
}
