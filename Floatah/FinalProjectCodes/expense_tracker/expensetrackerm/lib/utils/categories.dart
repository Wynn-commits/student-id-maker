import 'package:flutter/material.dart';

class Categories {
  static const List<String> expense = [
    'Food',
    'Transport',
    'School',
    'Bills',
    'Shopping',
    'Health',
    'Entertainment',
    'Other',
  ];

  static const List<String> income = ['Allowance', 'Salary', 'Gift', 'Other'];

  static List<String> forType(bool isIncome) => isIncome ? income : expense;

  static IconData iconFor(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_bus;
      case 'School':
        return Icons.school;
      case 'Bills':
        return Icons.receipt_long;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Health':
        return Icons.medical_services;
      case 'Entertainment':
        return Icons.movie;
      case 'Allowance':
        return Icons.savings;
      case 'Salary':
        return Icons.work;
      case 'Gift':
        return Icons.card_giftcard;
      default:
        return Icons.category;
    }
  }
}
