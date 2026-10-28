import 'package:flutter/material.dart';
import '../models/cart_line.dart';
import '../services/shop_service.dart';
import '../utils/cart_tile.dart';
import '../utils/empty_state.dart';
import '../utils/format.dart';
import '../utils/messages.dart';
import '../utils/mybuttons.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartLine> _lines = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _lines = ShopService.getCartLines();

  void _reload() => setState(_load);

  // Quantity and total price calculations.
  double get _total => _lines.fold<double>(0, (sum, l) => sum + l.subtotal);
  int get _itemCount => _lines.fold<int>(0, (sum, l) => sum + l.quantity);

  Future<void> _changeQuantity(CartLine line, int quantity) async {
    await ShopService.setQuantity(line.product.id, quantity);
    if (!mounted) return;
    _reload();
  }

  Future<void> _confirmDelete(CartLine line) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Remove item?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('"${line.product.name}" will be removed from your cart.'),
        actions: [
          MyButtons(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
          MyButtons(
            text: 'Remove',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ShopService.removeFromCart(line.product.id);
    if (!mounted) return;
    _reload();
    showMessage(context, 'Removed from cart');
  }

  Future<void> _checkout() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CheckoutPage()),
    );
    if (!mounted) return;
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Cart')),
      body: _lines.isEmpty
          ? EmptyState(
              icon: Icons.shopping_cart_outlined,
              message: 'Your cart is empty.\nBrowse the shop and add something!',
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: _lines.length,
                    itemBuilder: (context, index) {
                      final line = _lines[index];
                      return CartTile(
                        line: line,
                        onQuantityChanged: (q) => _changeQuantity(line, q),
                        onDelete: () => _confirmDelete(line),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1F000000),
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Total ($_itemCount ${_itemCount == 1 ? 'item' : 'items'})',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          Text(
                            formatMoney(_total),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange.shade700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      FilledButton(
                        onPressed: _checkout,
                        child: Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
