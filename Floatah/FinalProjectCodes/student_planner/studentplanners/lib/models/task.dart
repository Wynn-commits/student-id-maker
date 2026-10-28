/// One planner task. Hive stores it as a Map (see toMap / fromMap),
/// so no adapters or code generation are needed.
class Task {
  final String id;
  String title;
  String subject;
  DateTime deadline;
  String priority; // 'Low', 'Medium', or 'High'
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.subject,
    required this.deadline,
    this.priority = 'Medium',
    this.isDone = false,
  });

  /// True when the task is not finished and its deadline is before today.
  bool get isOverdue {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return !isDone && deadline.isBefore(today);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subject': subject,
        'deadline': deadline.toIso8601String(),
        'priority': priority,
        'isDone': isDone,
      };

  factory Task.fromMap(Map<dynamic, dynamic> map) => Task(
        id: map['id'] as String,
        title: map['title'] as String,
        subject: map['subject'] as String,
        deadline: DateTime.parse(map['deadline'] as String),
        priority: map['priority'] as String,
        isDone: map['isDone'] as bool,
      );
}
