import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/shop_service.dart';
import '../utils/empty_state.dart';
import '../utils/messages.dart';
import '../utils/product_card.dart';
import 'product_details_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Product> _favorites = [];
  Set<String> _ids = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _ids = ShopService.favoriteIds();
    _favorites = ShopService.getProducts().where((p) => _ids.contains(p.id)).toList();
  }

  void _reload() => setState(_load);

  Future<void> _openDetails(Product product) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailsPage(product: product)),
    );
    if (!mounted) return;
    _reload();
  }

  Future<void> _removeFavorite(Product product) async {
    await ShopService.toggleFavorite(product.id);
    if (!mounted) return;
    _reload();
    showMessage(context, 'Removed from favorites');
  }

  Future<void> _addToCart(Product product) async {
    await ShopService.addToCart(product.id);
    if (!mounted) return;
    showMessage(context, '${product.name} added to cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: _favorites.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border,
              message: 'No favorites yet.\nTap the heart on a product to save it here.',
            )
          : ProductGrid(
              products: _favorites,
              favoriteIds: _ids,
              onOpen: _openDetails,
              onToggleFavorite: _removeFavorite,
              onAddToCart: _addToCart,
            ),
    );
  }
}
