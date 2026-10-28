class Product {
  final String id;
  String name;
  String description;
  double price;
  String category;

  Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    required this.category,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
      };

  factory Product.fromMap(Map<dynamic, dynamic> map) => Product(
        id: map['id'] as String,
        name: map['name'] as String,
        description: (map['description'] as String?) ?? '',
        price: (map['price'] as num).toDouble(),
        category: map['category'] as String,
      );
}
