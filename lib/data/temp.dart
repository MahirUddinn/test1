import 'package:uuid/uuid.dart';
import 'package:test1/models/task_model.dart';

final uuid = Uuid();

final List<TaskModel> dummyTasks = [
  TaskModel(
    id: uuid.v4(),
    todoId: 'todo_1',
    title: 'Buy groceries',
    description: 'Get milk, eggs, bread, and vegetables.',
    checkBox: false,
  ),
  TaskModel(
    id: uuid.v4(),
    todoId: 'todo_1',
    title: 'Clean kitchen',
    description: 'Wipe counters, mop floor, and wash dishes.',
    checkBox: true,
  ),
  TaskModel(
    id: uuid.v4(),
    todoId: 'todo_2',
    title: 'Finish report',
    description: 'Complete the financial report by evening.',
    checkBox: false,
  ),
  TaskModel(
    id: uuid.v4(),
    todoId: 'todo_2',
    title: 'Email supervisor',
    description: 'Send the weekly update email to the supervisor.',
    checkBox: true,
  ),
  TaskModel(
    id: uuid.v4(),
    todoId: 'todo_3',
    title: 'Workout',
    description: 'Go for a 30-minute run and do stretching.',
    checkBox: false,
  ),
  TaskModel(
    id: uuid.v4(),
    todoId: 'todo_3',
    title: 'Meditation',
    description: 'Spend 15 minutes meditating before bed.',
    checkBox: true,
  ),
  TaskModel(
    id: uuid.v4(),
    todoId: 'todo_4',
    title: 'Study Flutter',
    description: 'Learn about Bloc state management and pagination.',
    checkBox: false,
  ),
  TaskModel(
    id: uuid.v4(),
    todoId: 'todo_4',
    title: 'Code review',
    description: 'Review the new pull request on GitHub.',
    checkBox: true,
  ),
  TaskModel(
    id: uuid.v4(),
    todoId: 'todo_5',
    title: 'Call parents',
    description: 'Catch up with parents about their week.',
    checkBox: false,
  ),
  TaskModel(
    id: uuid.v4(),
    todoId: 'todo_5',
    title: 'Plan weekend trip',
    description: 'Look for nearby places to visit and book transport.afjfnjoiafuifh',
    checkBox: false,
  ),
];
