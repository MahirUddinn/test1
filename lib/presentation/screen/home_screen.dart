import 'package:flutter/material.dart';
import 'package:test1/data/temp.dart';
import 'package:test1/models/todo_model.dart';
import 'package:test1/presentation/screen/add_screen.dart';
import 'package:test1/presentation/widget/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My ToDos")),
      body: _buildList(dummyTodos),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildList(List<TodoModel> itemList) {
    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, index) => TodoItem(item: itemList[index]),
    );
  }
}
