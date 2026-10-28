class ExpenseEntry {
  final String id;
  String title;
  double amount;
  String category;
  DateTime date;
  bool isIncome;

  ExpenseEntry({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.isIncome,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
        'isIncome': isIncome,
      };

  factory ExpenseEntry.fromMap(Map<dynamic, dynamic> map) => ExpenseEntry(
        id: map['id'] as String,
        title: map['title'] as String,
        amount: (map['amount'] as num).toDouble(),
        category: map['category'] as String,
        date: DateTime.parse(map['date'] as String),
        isIncome: map['isIncome'] as bool,
      );
}
