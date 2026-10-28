import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_entry.dart';

class ExpenseService {
  static const String boxName = 'expenses';

  static Box get _box => Hive.box(boxName);

  /// Newest date usa.
  static List<ExpenseEntry> getAll() {
    final entries = _box.values
        .map((item) => ExpenseEntry.fromMap(Map<dynamic, dynamic>.from(item)))
        .toList();
    entries.sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      return byDate != 0 ? byDate : b.id.compareTo(a.id);
    });
    return entries;
  }

//pang edit ug ad
  static Future<void> save(ExpenseEntry entry) =>
      _box.put(entry.id, entry.toMap());

  static Future<void> delete(String id) => _box.delete(id);
}
