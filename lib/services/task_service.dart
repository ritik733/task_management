import '../models/task.dart';

class TaskService {
  // This is a simple in-memory implementation
  // Replace this with your actual database implementation
  final List<Task> _tasks = [];

  Future<List<Task>> getTasks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    return _tasks;
  }

  Future<void> addTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _tasks.add(task);
  }

  Future<void> updateTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  Future<void> deleteTask(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _tasks.removeWhere((task) => task.id == id);
  }
}