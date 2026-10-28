import 'package:flutter/material.dart';
import 'categories.dart';

/// Stand-in "picture" for a product: a colored box with the category icon.
/// (No image files or internet needed.)
class ProductArt extends StatelessWidget {
  final String category;
  final double iconSize;
  final BorderRadius? borderRadius;

  const ProductArt({
    super.key,
    required this.category,
    this.iconSize = 48,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final color = Categories.colorFor(category);
    return Container(
      decoration: BoxDecoration(
        color: color.shade100,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(
          Categories.iconFor(category),
          size: iconSize,
          color: color.shade700,
        ),
      ),
    );
  }
}
