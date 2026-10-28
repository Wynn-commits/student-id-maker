import 'package:flutter/material.dart';
import '../models/cart_line.dart';
import 'format.dart';
import 'product_art.dart';
import 'quantity_stepper.dart';

class CartTile extends StatelessWidget {
  final CartLine line;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onDelete;

  const CartTile({
    super.key,
    required this.line,
    required this.onQuantityChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final product = line.product;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: ProductArt(
              category: product.category,
              iconSize: 30,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  formatMoney(product.price),
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 6),
                QuantityStepper(
                  quantity: line.quantity,
                  onChanged: onQuantityChanged,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                iconSize: 22,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 14),
              Text(
                formatMoney(line.subtotal),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
