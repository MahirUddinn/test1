import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == TodoStatus.error) {
          return Scaffold(
            appBar: AppBar(title: const Text("My ToDos")),
            body: Center(
              child: Text(state.errorMessage ?? "An error occurred"),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("My ToDos"),
            actions: [_buildFilter(), _buildReset()],
          ),
          body: state.todos.isEmpty
              ? _buildEmptyState(context)
              : _buildList(state.todos),
          floatingActionButton: _buildFloatingActionButton(),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No To-Dos Found",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            "Tap the '+' button to add your first To-Do.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildReset() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () {
        context.read<TodoCubit>().loadTodos();
      },
    );
  }

  Widget _buildFilter() {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () {
        context.read<TodoCubit>().filteredTodos();
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      heroTag: "btn1",
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => BlocProvider.value(
              value: context.read<TodoCubit>(),
              child: const AddScreen(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(List<TodoModel> itemList) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        controller: _scrollController,
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return TodoItem(
            item: itemList[index],
            onTapEdit: () => onEdit(itemList[index]),
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
