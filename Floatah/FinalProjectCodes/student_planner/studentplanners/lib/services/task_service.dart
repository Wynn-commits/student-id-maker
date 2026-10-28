import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

/// All Hive reading/writing lives here, so the pages stay clean.
class TaskService {
  static String boxName = 'tasks';

  static Box get _box => Hive.box(boxName);

  /// Pending tasks first (earliest deadline on top), completed tasks last.
  static List<Task> getAll() {
    final tasks = _box.values
        .map((item) => Task.fromMap(Map<dynamic, dynamic>.from(item)))
        .toList();
    tasks.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      return a.deadline.compareTo(b.deadline);
    });
    return tasks;
  }

  /// Used for BOTH adding and editing (same id = overwrite).
  static Future<void> save(Task task) => _box.put(task.id, task.toMap());

  static Future<void> delete(String id) => _box.delete(id);
}
