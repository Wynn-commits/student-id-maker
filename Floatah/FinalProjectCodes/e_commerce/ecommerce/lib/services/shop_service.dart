import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/cart_line.dart';
import '../models/product.dart';
import '../models/shop_order.dart';

class ShopService {
  static const _productsName = 'products';
  static const _cartName = 'cart';
  static const _favoritesName = 'favorites';
  static const _ordersName = 'orders';
  static const _metaName = 'meta';

  static final ValueNotifier<int> cartCount = ValueNotifier<int>(0);

  static Box get _products => Hive.box(_productsName);
  static Box get _cart => Hive.box(_cartName);
  static Box get _favorites => Hive.box(_favoritesName);
  static Box get _orders => Hive.box(_ordersName);
  static Box get _meta => Hive.box(_metaName);

  static Future<void> init() async {
    await Hive.openBox(_productsName);
    await Hive.openBox(_cartName);
    await Hive.openBox(_favoritesName);
    await Hive.openBox(_ordersName);
    await Hive.openBox(_metaName);

    if (_meta.get('seeded') != true) {
      for (final product in _sampleProducts()) {
        await _products.put(product.id, product.toMap());
      }
      await _meta.put('seeded', true);
    }
    _updateCartCount();
  }

  // ---------------------------------------------------------------- products secktor

  static List<Product> getProducts() {
    final list = _products.values
        .map((e) => Product.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList();
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  static Future<void> saveProduct(Product product) =>
      _products.put(product.id, product.toMap());

  static Future<void> deleteProduct(String id) async {
    await _products.delete(id);
    await _cart.delete(id);
    await _favorites.delete(id);
    _updateCartCount();
  }

  // -------------------------------------------------------------------- cart secktor

  static int _quantityOf(String productId) => (_cart.get(productId) as int?) ?? 0;

  static Future<void> addToCart(String productId, {int quantity = 1}) async {
    await _cart.put(productId, _quantityOf(productId) + quantity);
    _updateCartCount();
  }

  static Future<void> setQuantity(String productId, int quantity) async {
    await _cart.put(productId, quantity);
    _updateCartCount();
  }

  static Future<void> removeFromCart(String productId) async {
    await _cart.delete(productId);
    _updateCartCount();
  }

  static List<CartLine> getCartLines() {
    final lines = <CartLine>[];
    for (final key in _cart.keys) {
      final raw = _products.get(key);
      if (raw == null) continue; // product no longer exists
      lines.add(CartLine(
        product: Product.fromMap(Map<dynamic, dynamic>.from(raw)),
        quantity: _cart.get(key) as int,
      ));
    }
    lines.sort((a, b) => a.product.name.compareTo(b.product.name));
    return lines;
  }

  static void _updateCartCount() {
    cartCount.value = _cart.values.fold<int>(0, (sum, q) => sum + (q as int));
  }

  // --------------------------------------------------------------- favorites secktor

  static Set<String> favoriteIds() =>
      _favorites.keys.map((k) => k.toString()).toSet();

  static Future<void> toggleFavorite(String productId) async {
    if (_favorites.containsKey(productId)) {
      await _favorites.delete(productId);
    } else {
      await _favorites.put(productId, true);
    }
  }

  // ------------------------------------------------------------------ orders secktor

  /// Newest first.
  static List<ShopOrder> getOrders() {
    final list = _orders.values
        .map((e) => ShopOrder.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  static Future<ShopOrder> placeOrder({
    required String customerName,
    required String phone,
    required String address,
    required String payment,
  }) async {
    final lines = getCartLines();
    final now = DateTime.now();
    final order = ShopOrder(
      id: now.millisecondsSinceEpoch.toString(),
      date: now,
      customerName: customerName,
      phone: phone,
      address: address,
      payment: payment,
      total: lines.fold<double>(0, (sum, l) => sum + l.subtotal),
      lines: lines
          .map((l) => OrderLine(
                name: l.product.name,
                price: l.product.price,
                quantity: l.quantity,
              ))
          .toList(),
    );
    await _orders.put(order.id, order.toMap());
    await _cart.clear();
    _updateCartCount();
    return order;
  }

  // ------------------------------------------------------------- sample data

  static List<Product> _sampleProducts() => [
        Product(id: 'p01', name: 'Wireless Earbuds', price: 1299, category: 'Electronics', description: 'Bluetooth earbuds with a charging case and up to 20 hours of battery life.'),
        Product(id: 'p02', name: 'Power Bank 10,000mAh', price: 699, category: 'Electronics', description: 'Slim power bank with fast charging and two USB ports.'),
        Product(id: 'p03', name: 'Smart Watch', price: 1899, category: 'Electronics', description: 'Tracks steps, heart rate, and sleep. Shows phone notifications.'),
        Product(id: 'p04', name: 'Cotton T-Shirt', price: 249, category: 'Fashion', description: 'Soft, breathable cotton shirt for everyday wear.'),
        Product(id: 'p05', name: 'Canvas Backpack', price: 599, category: 'Fashion', description: 'Roomy backpack with a padded laptop pocket. Great for school.'),
        Product(id: 'p06', name: 'Running Sneakers', price: 1499, category: 'Fashion', description: 'Lightweight sneakers with a cushioned sole.'),
        Product(id: 'p07', name: 'Dried Mango Pack', price: 120, category: 'Food', description: 'Sweet and chewy dried mango slices. 100g pack.'),
        Product(id: 'p08', name: 'Instant Coffee Box', price: 180, category: 'Food', description: 'Box of 20 instant coffee sachets. Rich and smooth.'),
        Product(id: 'p09', name: 'Notebook Set (3 pcs)', price: 150, category: 'Books', description: 'Three ruled notebooks, 80 pages each.'),
        Product(id: 'p10', name: 'Beginner Flutter Guide', price: 650, category: 'Books', description: 'Step-by-step guide to building your first mobile apps.'),
        Product(id: 'p11', name: 'LED Desk Lamp', price: 450, category: 'Home', description: 'Adjustable desk lamp with three brightness levels.'),
        Product(id: 'p12', name: 'Ceramic Mug', price: 160, category: 'Home', description: 'Sturdy 350ml mug, microwave and dishwasher safe.'),
      ];
}
