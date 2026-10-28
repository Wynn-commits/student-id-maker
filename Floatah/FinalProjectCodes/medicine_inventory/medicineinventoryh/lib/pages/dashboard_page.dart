import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/medicine_service.dart';
import '../utils/categories.dart';
import '../utils/status_chips.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  static const _shadow = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 6, offset: Offset(0, 2)),
  ];

  @override
  Widget build(BuildContext context) {
    final medicines = MedicineService.getMedicines();

    final total = medicines.length;
    final units = medicines.fold<int>(0, (sum, m) => sum + m.quantity);
    final low = medicines.where((m) => m.isLowStock).length;
    final out = medicines.where((m) => m.isOutOfStock).length;
    final near = medicines.where((m) => m.isNearExpiry).length;
    final expired = medicines.where((m) => m.isExpired).length;

    // Most urgent first ari dapit unahon
    final attention = medicines.where((m) => m.needsAttention).toList()
      ..sort((a, b) {
        final byUrgency = a.urgency.compareTo(b.urgency);
        if (byUrgency != 0) return byUrgency;
        return a.daysUntilExpiry.compareTo(b.daysUntilExpiry);
      });

    final countByCategory = <String, int>{};
    final unitsByCategory = <String, int>{};
    for (final m in medicines) {
      countByCategory[m.category] = (countByCategory[m.category] ?? 0) + 1;
      unitsByCategory[m.category] = (unitsByCategory[m.category] ?? 0) + m.quantity;
    }
    final categories =
        Categories.list.where((c) => countByCategory.containsKey(c)).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Medicine Inventory')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _StatCard(label: 'Medicines', value: total, icon: Icons.local_pharmacy, color: Colors.teal),
              _StatCard(label: 'Units in stock', value: units, icon: Icons.inventory_2, color: Colors.blue),
              _StatCard(label: 'Low stock', value: low, icon: Icons.warning_amber_rounded, color: Colors.amber),
              _StatCard(label: 'Out of stock', value: out, icon: Icons.block, color: Colors.blueGrey),
              _StatCard(label: 'Near expiry', value: near, icon: Icons.hourglass_bottom, color: Colors.orange),
              _StatCard(label: 'Expired', value: expired, icon: Icons.event_busy, color: Colors.red),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Needs attention',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (attention.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Everything looks good. No low-stock or expiring medicines.',
                style: TextStyle(color: Colors.black54),
              ),
            )
          else ...[
            ...attention.take(5).map((m) => _AttentionCard(medicine: m)),
            if (attention.length > 5)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  '+ ${attention.length - 5} more in the Medicines tab',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
          ],
          SizedBox(height: 24),
          Text(
            'Summary by category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (categories.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No medicines yet.',
                style: TextStyle(color: Colors.black54),
              ),
            )
          else
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: _shadow,
              ),
              child: Column(
                children: categories.map((c) {
                  final count = countByCategory[c]!;
                  final units = unitsByCategory[c]!;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Icon(Categories.iconFor(c), size: 20, color: Colors.teal.shade700),
                        SizedBox(width: 10),
                        Expanded(child: Text(c)),
                        Text(
                          '$count ${count == 1 ? 'medicine' : 'medicines'}  •  $units units',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final MaterialColor color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: DashboardPage._shadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.shade50,
            child: Icon(icon, size: 18, color: color.shade700),
          ),
          const SizedBox(height: 6),
          Text(
            '$value',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class _AttentionCard extends StatelessWidget {
  final Medicine medicine;

  const _AttentionCard({required this.medicine});

  @override
  Widget build(BuildContext context) {
    final m = medicine;
    final color = severityColor(m);

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: DashboardPage._shadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.shade50,
            child: Icon(Categories.iconFor(m.category), color: color.shade700),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.displayName,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  expiryLabel(m),
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                SizedBox(height: 6),
                StatusChips(medicine: m),
              ],
            ),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${m.quantity}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                'in stock',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
