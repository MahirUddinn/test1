import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/models/todo_model.dart';
import 'package:test1/presentation/bloc/todo_cubit.dart';
import 'package:test1/presentation/screen/add_screen.dart';
import 'package:test1/presentation/widget/todo_item.dart';

import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TodoCubit>().loadTodos();
  }

  void onEdit(TodoModel item) async {
    final TodoModel? todo = await Navigator.of(
      context,
    ).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: this.context.read<TodoCubit>(),
          child: EditScreen(todo: item),
        ),
      ),
    );
    if (todo != null) {
      context.read<TodoCubit>().updateNote(todo);
    }
  }

  void onCheck(item) {
    final todo = TodoModel(
      id: item.id,
      title: item.title,
      description: item.description,
      date: item.date,
      checkBox: !item.checkBox,
    );
    context.read<TodoCubit>().updateNote(todo);
  }

  Future refresh() async {
    context.read<TodoCubit>().loadTodos();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        if (state.status == TodoStatus.loading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state.status == TodoStatus.loaded) {
          return Scaffold(
            appBar: AppBar(
              title: Text("My ToDos"),
              actions: [
                _buildSorter()
              ],
            ),
            body: state.todos.isEmpty?Center(child: Text("No data found"),):_buildList(state.todos),
            floatingActionButton: _buildFloatingActionButton(),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildSorter(){
    return ElevatedButton(
      onPressed: () {
        context.read<TodoCubit>().sortedTodos();
      },
      child: Text("Sort Checklist"),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => BlocProvider.value(
              value: BlocProvider.of<TodoCubit>(context),
              child: AddScreen(),
            ),
          ),
        );
      },
      child: Icon(Icons.add),
    );
  }

  Widget _buildList(List<TodoModel> itemList) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) => TodoItem(
          item: itemList[index],
          onTapEdit: () {
            onEdit(itemList[index]);
          },
          onTapCheck: () {
            onCheck(itemList[index]);
          },
        ),
      ),
    );
  }
}
