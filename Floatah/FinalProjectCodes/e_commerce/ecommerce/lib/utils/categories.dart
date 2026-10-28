import 'package:flutter/material.dart';

class Categories {
  static const List<String> list = [
    'Electronics',
    'Fashion',
    'Food',
    'Books',
    'Home',
    'Other',
  ];

  static IconData iconFor(String category) {
    switch (category) {
      case 'Electronics':
        return Icons.devices;
      case 'Fashion':
        return Icons.checkroom;
      case 'Food':
        return Icons.fastfood;
      case 'Books':
        return Icons.menu_book;
      case 'Home':
        return Icons.chair;
      default:
        return Icons.category;
    }
  }

  static MaterialColor colorFor(String category) {
    switch (category) {
      case 'Electronics':
        return Colors.blue;
      case 'Fashion':
        return Colors.pink;
      case 'Food':
        return Colors.orange;
      case 'Books':
        return Colors.brown;
      case 'Home':
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }
}
