import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'to_do_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Tasks Table
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        dueDate TEXT
      )
    ''');

    // Create Visions Table
    await db.execute('''
      CREATE TABLE visions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        type TEXT NOT NULL, -- "monthly" or "yearly"
        period TEXT NOT NULL, -- Month name or year
        isAchieved INTEGER DEFAULT 0
      )
    ''');
  }

  // -------------------- TASKS OPERATIONS --------------------

  Future<int> addTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert('tasks', task);
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await database;
    return await db.query('tasks');
  }

  Future<int> updateTask(int id, Map<String, dynamic> updates) async {
    final db = await database;
    return await db.update(
      'tasks',
      updates,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -------------------- VISIONS OPERATIONS --------------------

  Future<int> addVision(Map<String, dynamic> vision) async {
    final db = await database;
    return await db.insert('visions', vision);
  }

  Future<List<Map<String, dynamic>>> getVisionsByPeriod(String period, String type) async {
    final db = await database;
    return await db.query(
      'visions',
      where: 'period = ? AND type = ?',
      whereArgs: [period, type],
    );
  }

  Future<int> updateVision(int id, Map<String, dynamic> updates) async {
    final db = await database;
    return await db.update(
      'visions',
      updates,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteVision(int id) async {
    final db = await database;
    return await db.delete(
      'visions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}