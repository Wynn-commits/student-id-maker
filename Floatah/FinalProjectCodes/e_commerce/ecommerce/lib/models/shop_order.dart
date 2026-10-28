class OrderLine {
  final String name;
  final double price;
  final int quantity;

  OrderLine({required this.name, required this.price, required this.quantity});

  double get subtotal => price * quantity;

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'quantity': quantity,
      };

  factory OrderLine.fromMap(Map<dynamic, dynamic> map) => OrderLine(
        name: map['name'] as String,
        price: (map['price'] as num).toDouble(),
        quantity: map['quantity'] as int,
      );
}

class ShopOrder {
  final String id;
  final DateTime date;
  final String customerName;
  final String phone;
  final String address;
  final String payment;
  final double total;
  final List<OrderLine> lines;

  ShopOrder({
    required this.id,
    required this.date,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.payment,
    required this.total,
    required this.lines,
  });

  String get shortId => '#${id.substring(id.length - 6)}';

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'customerName': customerName,
        'phone': phone,
        'address': address,
        'payment': payment,
        'total': total,
        'items': lines.map((l) => l.toMap()).toList(),
      };

  factory ShopOrder.fromMap(Map<dynamic, dynamic> map) => ShopOrder(
        id: map['id'] as String,
        date: DateTime.parse(map['date'] as String),
        customerName: map['customerName'] as String,
        phone: map['phone'] as String,
        address: map['address'] as String,
        payment: map['payment'] as String,
        total: (map['total'] as num).toDouble(),
        lines: (map['items'] as List)
            .map((e) => OrderLine.fromMap(Map<dynamic, dynamic>.from(e as Map)))
            .toList(),
      );
}
