import 'package:flutter/material.dart';
import '../services/shop_service.dart';
import 'cart_page.dart';
import 'favorites_page.dart';
import 'orders_page.dart';
import 'shop_page.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    ShopPage(),
    FavoritesPage(),
    CartPage(),
    OrdersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.storefront),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            // The little number on the cart icon updates automatically.
            icon: ValueListenableBuilder<int>(
              valueListenable: ShopService.cartCount,
              builder: (context, count, _) => Badge(
                isLabelVisible: count > 0,
                label: Text('$count'),
                child: Icon(Icons.shopping_cart_outlined),
              ),
            ),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
