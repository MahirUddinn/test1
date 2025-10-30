import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/data/database_helper.dart';
import 'package:test1/models/todo_model.dart';
import 'package:test1/presentation/bloc/task_cubit/task_cubit.dart';
import 'package:test1/presentation/bloc/todo_cubit/todo_cubit.dart';
import 'package:test1/presentation/screen/add_screen.dart';
import 'package:test1/presentation/screen/detailed_screen.dart';
import 'package:test1/presentation/widget/todo_item.dart';

import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  void _loadPaginatedData() {
    context.read<TodoCubit>().loadNextPage();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadPaginatedData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadPaginatedData();
    }
  }

  void onEdit(TodoModel item) async {
    final TodoModel? todo = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => BlocProvider.value(
          value: BlocProvider.of<TodoCubit>(context),
          child: EditScreen(todo: item),
        ),
      ),
    );

    if (todo != null) {
      context.read<TodoCubit>().updateTodo(todo);
    }
  }

  Future refresh() async {
    context.read<TodoCubit>().loadTodos();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        if (state.status == TodoStatus.loading && state.todos.isEmpty) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state.status == TodoStatus.error) {
          return Scaffold(
            appBar: AppBar(title: Text("My ToDos")),
            body: Center(
              child: Text(state.errorMessage ?? "An error occurred"),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("My ToDos"),
            actions: [_buildReset(), _buildFilter()],
          ),
          body: state.todos.isEmpty
              ? Center(child: Text("No data found"))
              : _buildList(state.todos),
          floatingActionButton: _buildFloatingActionButton(),
        );
      },
    );
  }

  Widget _buildReset() {
    return TextButton(
      onPressed: () {
        context.read<TodoCubit>().loadTodos();
      },
      child: Text("Reset"),
    );
  }

  Widget _buildFilter() {
    return ElevatedButton(
      onPressed: () {
        context.read<TodoCubit>().filteredTodos();
      },
      child: Text("Toggle filter"),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      heroTag: "btn1",
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => BlocProvider.value(
              value: context.read<TodoCubit>(),
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
        controller: _scrollController,
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: TodoItem(
              item: itemList[index],
              onTapEdit: () => onEdit(itemList[index]),
            ),
            onTap: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => BlocProvider.value(
                    value: BlocProvider.of<TaskCubit>(context),
                    child: DetailedScreen(
                      todo: itemList[index],
                      onTodoCheck: () {
                        context.read<TodoCubit>().loadTodos();
                      },
                    ),
                  ),
                ),
              );
              context.read<TodoCubit>().loadTodos();
            },
          );
        },
      ),
    );
  }
}
