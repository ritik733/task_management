import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

final taskProvider = StateNotifierProvider<TaskViewModel, List<Task>>((ref) {
  return TaskViewModel();
});

class TaskViewModel extends StateNotifier<List<Task>> {
  Database? _database;

  TaskViewModel() : super([]) {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'tasks.db');

    _database = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE tasks(
            id INTEGER PRIMARY KEY, 
            title TEXT, 
            description TEXT, 
            date TEXT, 
            isCompleted INTEGER,
            priority INTEGER DEFAULT 1
          )''',
        );
      },
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE tasks ADD COLUMN priority INTEGER DEFAULT 1');
        }
      },
    );

    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final List<Map<String, dynamic>> maps = await _database!.query('tasks');
    state = List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<void> addTask(Task task) async {
    await _database!.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    await _database!.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    _fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await _database!.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    _fetchTasks();
  }

  Future<void> toggleTaskStatus(int id) async {
    final task = state.firstWhere((task) => task.id == id);
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      date: task.date,
      isCompleted: !task.isCompleted,
      priority: task.priority,
    );
    await updateTask(updatedTask);
  }
}