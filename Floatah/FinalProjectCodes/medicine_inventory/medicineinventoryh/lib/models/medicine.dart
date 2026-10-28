class Medicine {
  static const int nearExpiryDays = 30;

  final String id;
  String name;
  String strength; // e.g. "500mg" ganun
  String category;
  int quantity; 
  int minStock; 
  DateTime expiryDate;

  Medicine({
    required this.id,
    required this.name,
    this.strength = '',
    required this.category,
    required this.quantity,
    required this.minStock,
    required this.expiryDate,
  });

  /// "Paracetamol 500mg" sample
  String get displayName => strength.isEmpty ? name : '$name $strength';

  static DateTime _dateOnly(DateTime d) => DateTime.utc(d.year, d.month, d.day);

  int get daysUntilExpiry =>
      _dateOnly(expiryDate).difference(_dateOnly(DateTime.now())).inDays;

  bool get isExpired => daysUntilExpiry < 0;
  bool get isNearExpiry => !isExpired && daysUntilExpiry <= nearExpiryDays;
  bool get isOutOfStock => quantity == 0;
  bool get isLowStock => quantity > 0 && quantity <= minStock;
  bool get needsAttention =>
      isExpired || isNearExpiry || isOutOfStock || isLowStock;

  int get urgency {
    if (isExpired) return 0;
    if (isNearExpiry) return 1;
    if (isOutOfStock) return 2;
    if (isLowStock) return 3;
    return 4;
  }

  String get expiryStatusText {
    final days = daysUntilExpiry;
    if (days < 0) {
      final ago = -days;
      return 'Expired $ago ${ago == 1 ? 'day' : 'days'} ago';
    }
    if (days == 0) return 'Expires today';
    if (days == 1) return 'Expires tomorrow';
    return 'Expires in $days days';
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'strength': strength,
        'category': category,
        'quantity': quantity,
        'minStock': minStock,
        'expiryDate': expiryDate.toIso8601String(),
      };

  factory Medicine.fromMap(Map<dynamic, dynamic> map) => Medicine(
        id: map['id'] as String,
        name: map['name'] as String,
        strength: (map['strength'] as String?) ?? '',
        category: map['category'] as String,
        quantity: map['quantity'] as int,
        minStock: map['minStock'] as int,
        expiryDate: DateTime.parse(map['expiryDate'] as String),
      );
}
