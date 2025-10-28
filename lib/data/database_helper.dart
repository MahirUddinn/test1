import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
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
    return List.generate(maps.length, (index) {
      return TodoModel(
          id: maps[index]['id'],
          title:maps[index]['title'],
          description: maps[index]['description'],
          date: maps[index]['date'],
          checkBox: maps[index]['id'] == 1);
    },);
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
