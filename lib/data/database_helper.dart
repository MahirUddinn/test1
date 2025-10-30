import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test1/models/task_model.dart';
import 'package:test1/models/todo_model.dart';

class AppDatabase {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    return await openDatabase(path, version: 2, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        date TEXT,
        checkBox INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks(
        id TEXT PRIMARY KEY,
        todoId TEXT,
        title TEXT,
        description TEXT,
        checkBox INTEGER
      )
    ''');
  }




  Future<void> addTodo(TodoModel todo) async {
    final db = await database;
    await db.insert('todos', todo.toMap());
  }

  Future<void> addTask(TaskModel task) async {
    final db = await database;
    await db.insert('tasks', task.toMap());
  }

  Future<List<TodoModel>> getTodos() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      orderBy: 'rowid DESC',
    );
    return [
      for (final map in maps)
        TodoModel(
          id: map['id'],
          title: map['title'],
          description: map['description'],
          date: map['date'],
          checkBox: map['checkBox'] == 1,
        ),
    ];
  }

  Future<List<TaskModel>> getTask(TodoModel todo) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      orderBy: 'rowid DESC',
      where: 'todoId = ?',
      whereArgs: [todo.id],
    );
    return [
      for (final map in maps)
        TaskModel(
          id: map['id'],
          todoId: map['todoId'],
          title: map['title'],
          description: map['description'],
          checkBox: map['checkBox'] == 1,
        ),
    ];
  }

  Future<int> deleteTasks(String id) async {
    Database db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTasks(TaskModel task) async {
    Database db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<List<TodoModel>> getPaginatedTodos(int limit, int offset) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      limit: limit,
      offset: offset,
      orderBy: 'rowid DESC',
    );
    return [
      for (final map in maps)
        TodoModel(
          id: map['id'],
          title: map['title'],
          description: map['description'],
          date: map['date'],
          checkBox: map['checkBox'] == 1,
        ),
    ];
  }

  Future<int> deleteTodos(String id) async {
    Database db = await database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTodos(TodoModel todo) async {
    Database db = await database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<List<TodoModel>> getLastItem() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'todos',
      orderBy: 'rowid DESC',
      limit: 1,
    );

    return [
      for (final map in results)
        TodoModel(
          id: map['id'],
          title: map['title'],
          description: map['description'],
          date: map['date'],
          checkBox: map['checkBox'] == 1,
        ),
    ];
  }

  Future<TodoModel?> getTodoById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    final map = results.first;
    return TodoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      checkBox: map['checkBox'] == 1,
    );
  }
}
