import 'product.dart';

class CartLine {
  final Product product;
  final int quantity;

  CartLine({required this.product, required this.quantity});

  double get subtotal => product.price * quantity;
}
