import 'package:flutter/material.dart';
import '../models/medicine.dart';
import 'format.dart';

MaterialColor severityColor(Medicine m) {
  if (m.isExpired) return Colors.red;
  if (m.isNearExpiry) return Colors.orange;
  if (m.isOutOfStock) return Colors.blueGrey;
  if (m.isLowStock) return Colors.amber;
  return Colors.green;
}

String expiryLabel(Medicine m) {
  if (m.isExpired || m.isNearExpiry) {
    return '${m.expiryStatusText} (${formatDate(m.expiryDate)})';
  }
  return 'Expires ${formatDate(m.expiryDate)}';
}

class StatusChips extends StatelessWidget {
  final Medicine medicine;

  const StatusChips({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final m = medicine;
    final flags = <String, MaterialColor>{
      if (m.isExpired) 'Expired': Colors.red,
      if (m.isNearExpiry) 'Near expiry': Colors.orange,
      if (m.isOutOfStock) 'Out of stock': Colors.blueGrey,
      if (m.isLowStock) 'Low stock': Colors.amber,
    };
    if (flags.isEmpty) flags['OK'] = Colors.green;

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: flags.entries
          .map(
            (e) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: e.value.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                e.key,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: e.value.shade900,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
