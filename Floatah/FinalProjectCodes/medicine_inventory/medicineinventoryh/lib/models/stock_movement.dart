class StockMovement {
  final String id;
  final String medicineId;
  final String medicineName;
  final bool isIn; // true = stock in, false = stock out
  final int quantity;
  final int balanceAfter; 
  final DateTime date;
  final String note;

  StockMovement({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    required this.isIn,
    required this.quantity,
    required this.balanceAfter,
    required this.date,
    this.note = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'medicineId': medicineId,
        'medicineName': medicineName,
        'isIn': isIn,
        'quantity': quantity,
        'balanceAfter': balanceAfter,
        'date': date.toIso8601String(),
        'note': note,
      };

  factory StockMovement.fromMap(Map<dynamic, dynamic> map) => StockMovement(
        id: map['id'] as String,
        medicineId: map['medicineId'] as String,
        medicineName: map['medicineName'] as String,
        isIn: map['isIn'] as bool,
        quantity: map['quantity'] as int,
        balanceAfter: map['balanceAfter'] as int,
        date: DateTime.parse(map['date'] as String),
        note: (map['note'] as String?) ?? '',
      );
}
