import 'package:flutter/material.dart';

class Categories {
  static const List<String> list = [
    'Pain Relief',
    'Antibiotic',
    'Allergy',
    'Vitamins',
    'Cough & Cold',
    'First Aid',
    'Other',
  ];

  static IconData iconFor(String category) {
    switch (category) {
      case 'Pain Relief':
        return Icons.healing;
      case 'Antibiotic':
        return Icons.local_pharmacy;
      case 'Allergy':
        return Icons.grass;
      case 'Vitamins':
        return Icons.eco;
      case 'Cough & Cold':
        return Icons.ac_unit;
      case 'First Aid':
        return Icons.medical_services;
      default:
        return Icons.category;
    }
  }
}
