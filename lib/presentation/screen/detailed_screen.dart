import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/models/task_model.dart';
import 'package:test1/models/todo_model.dart';
import 'package:test1/presentation/bloc/task_cubit/task_cubit.dart';
import 'package:test1/presentation/screen/task_add_screen.dart';
import 'package:test1/presentation/screen/task_edit_screen.dart';
import 'package:test1/presentation/widget/task_item.dart';

class DetailedScreen extends StatefulWidget {
  const DetailedScreen({
    super.key,
    required this.todo,
    required this.onTodoCheck,
  });

  final TodoModel todo;
  final VoidCallback onTodoCheck;

  @override
  State<DetailedScreen> createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen> {
  void openBottomModal() async {
    final task = await showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TaskAddScreen(todo: widget.todo);
      },
    );

    if (task != null) {
      widget.onTodoCheck();
      context.read<TaskCubit>().addTasks(task);
    }
  }

  void openEditScreen(TaskModel editTask) async {
    final task = await showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,

      builder: (context) {
        return TaskEditScreen(task: editTask);
      },
    );

    if (task != null) {
      widget.onTodoCheck();
      context.read<TaskCubit>().updateTask(task);
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().loadTasks(widget.todo);
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;

    return Scaffold(
      appBar: AppBar(title: Text(todo.title)),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        child: const Icon(Icons.add),
        onPressed: () {
          openBottomModal();
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDescription(context, todo),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Tasks", style: Theme.of(context).textTheme.titleLarge),
          ),
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              if (state.status == TaskStatus.loading && state.tasks.isEmpty) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state.status == TaskStatus.error) {
                return Expanded(
                  child: Center(child: Text(state.errorMessage!)),
                );
              }
              return Expanded(child: _buildTaskList(context, state.tasks));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_box_outline_blank,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No tasks yet",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              "Add a task to get started.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskItem(
          task: tasks[index],
          onCheck: () {
            context.read<TaskCubit>().updateTask(
              TaskModel(
                id: tasks[index].id,
                todoId: tasks[index].todoId,
                title: tasks[index].title,
                checkBox: !tasks[index].checkBox,
              ),
            );
            widget.onTodoCheck();
          },
          onEdit: () {
            openEditScreen(tasks[index]);
          },
        );
      },
    );
  }

  Widget _buildDescription(BuildContext context, TodoModel todo) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              todo.description.isEmpty
                  ? "No description was added for this todo."
                  : todo.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: todo.description.isEmpty
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
