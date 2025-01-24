import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'todo_app.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        dueDate TEXT
      )
    ''');
  }

  // Add Task
  Future<int> addTask(String title, String description, String? dueDate) async {
    final db = await database;
    return db.insert(
      'tasks',
      {
        'title': title,
        'description': description,
        'isCompleted': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'dueDate': dueDate,
      },
    );
  }

  // Get All Tasks
  Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await database;
    return db.query('tasks', orderBy: 'createdAt DESC');
  }

  // Update Task
  Future<int> updateTask(int id, Map<String, dynamic> updatedFields) async {
    final db = await database;
    return db.update(
      'tasks',
      updatedFields,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete Task
  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
