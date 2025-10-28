import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test1/models/todo_model.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

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
    return await openDatabase(path, version: 1, onCreate: _onCreate);
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
  }

  Future<int> addTodo(TodoModel todo) async {
    Database db = await database;
    return await db.insert(
      'todos',
      todo.toMap(),
    );
  }

  Future<List<TodoModel>> getTodos() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
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
}
