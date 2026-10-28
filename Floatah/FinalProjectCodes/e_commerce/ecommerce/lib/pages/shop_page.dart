import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/shop_service.dart';
import '../utils/categories.dart';
import '../utils/empty_state.dart';
import '../utils/messages.dart';
import '../utils/product_card.dart';
import 'manage_products_page.dart';
import 'product_details_page.dart';

/// Home screen: search, category filter, and the product catalog.
class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Product> _products = [];
  Set<String> _favorites = {};
  String _query = '';
  String _category = 'All';

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _products = ShopService.getProducts();
    _favorites = ShopService.favoriteIds();
  }

  void _reload() => setState(_load);

  /// Products that match the search text and the selected category.
  List<Product> get _visible {
    final query = _query.trim().toLowerCase();
    return _products.where((p) {
      final matchesCategory = _category == 'All' || p.category == _category;
      final matchesSearch = query.isEmpty || p.name.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _openDetails(Product product) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailsPage(product: product)),
    );
    if (!mounted) return;
    _reload(); // favorites may have changed on the details page
  }

  Future<void> _openManage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ManageProductsPage()),
    );
    if (!mounted) return;
    _reload(); // products may have been added, edited, or deleted
  }

  Future<void> _toggleFavorite(Product product) async {
    await ShopService.toggleFavorite(product.id);
    if (!mounted) return;
    _reload();
  }

  Future<void> _addToCart(Product product) async {
    await ShopService.addToCart(product.id);
    if (!mounted) return;
    showMessage(context, '${product.name} added to cart');
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Shop'),
        actions: [
          IconButton(
            onPressed: _openManage,
            tooltip: 'Manage products',
            icon: const Icon(Icons.inventory_2_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['All', ...Categories.list]
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(c),
                        selected: _category == c,
                        selectedColor: Colors.orange.shade200,
                        onSelected: (_) => setState(() => _category = c),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: visible.isEmpty
                ? EmptyState(
                    icon: Icons.search_off,
                    message: _products.isEmpty
                        ? 'The shop has no products.\nTap the box icon to add some.'
                        : 'No products found.',
                  )
                : ProductGrid(
                    products: visible,
                    favoriteIds: _favorites,
                    onOpen: _openDetails,
                    onToggleFavorite: _toggleFavorite,
                    onAddToCart: _addToCart,
                  ),
          ),
        ],
      ),
    );
  }
}
