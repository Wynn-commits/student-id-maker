import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/shop_service.dart';
import '../utils/categories.dart';
import '../utils/format.dart';
import '../utils/messages.dart';
import '../utils/product_art.dart';
import '../utils/quantity_stepper.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late bool _isFavorite;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _isFavorite = ShopService.favoriteIds().contains(widget.product.id);
  }

  Future<void> _toggleFavorite() async {
    await ShopService.toggleFavorite(widget.product.id);
    if (!mounted) return;
    setState(() => _isFavorite = !_isFavorite);
    showMessage(
      context,
      _isFavorite ? 'Added to favorites' : 'Removed from favorites',
    );
  }

  Future<void> _addToCart() async {
    await ShopService.addToCart(widget.product.id, quantity: _quantity);
    if (!mounted) return;
    showMessage(context, 'Added $_quantity × ${widget.product.name} to cart');
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product details'),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 220,
            child: ProductArt(category: product.category, iconSize: 96),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  formatMoney(product.price),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Chip(
                  avatar: Icon(Categories.iconFor(product.category), size: 18),
                  label: Text(product.category),
                  backgroundColor: Categories.colorFor(product.category).shade100,
                  side: BorderSide.none,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  product.description.isEmpty
                      ? 'No description provided.'
                      : product.description,
                  style: const TextStyle(height: 1.4, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              QuantityStepper(
                quantity: _quantity,
                onChanged: (q) => setState(() => _quantity = q),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _addToCart,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: Text('Add • ${formatMoney(product.price * _quantity)}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
