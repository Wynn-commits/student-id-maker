import 'package:flutter/material.dart';
import '../services/expense_service.dart';
import '../utils/categories.dart';
import '../utils/format.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const _shadow = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 6, offset: Offset(0, 2)),
  ];

  @override
  Widget build(BuildContext context) {
    final all = ExpenseService.getAll();

    double income = 0;
    double expense = 0;
    final byCategory = <String, double>{};
    for (final e in all) {
      if (e.isIncome) {
        income += e.amount;
      } else {
        expense += e.amount;
        byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amount;
      }
    }
    final balance = income - expense;
    final categoryTotals = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final recent = all.take(5).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Expense Tracker'), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Balance card
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade300,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _shadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current balance'),
                SizedBox(height: 4),
                Text(
                  formatMoney(balance),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: balance < 0 ? Colors.red.shade900 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'Income',
                  amount: income,
                  icon: Icons.arrow_downward,
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  label: 'Expenses',
                  amount: expense,
                  icon: Icons.arrow_upward,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Spending by category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (categoryTotals.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No expenses yet.',
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
                children: categoryTotals.map((item) {
                  final fraction = expense == 0 ? 0.0 : item.value / expense;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Categories.iconFor(item.key), size: 20),
                            SizedBox(width: 8),
                            Expanded(child: Text(item.key)),
                            Text(
                              formatMoney(item.value),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: fraction,
                            minHeight: 8,
                            color: Colors.red.shade300,
                            backgroundColor: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          SizedBox(height: 12),
          Text(
            'Recent transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (recent.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No transactions yet.',
                style: TextStyle(color: Colors.black54),
              ),
            )
          else
            ...recent.map((e) {
              final color = e.isIncome ? Colors.green : Colors.red;
              return Card(
                color: Colors.white,
                elevation: 1,
                surfaceTintColor: Colors.transparent,
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.shade50,
                    child: Icon(
                      Categories.iconFor(e.category),
                      color: color.shade700,
                    ),
                  ),
                  title: Text(e.title),
                  subtitle: Text('${e.category}  •  ${formatDate(e.date)}'),
                  trailing: Text(
                    '${e.isIncome ? '+' : '-'}${formatMoney(e.amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color.shade700,
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final MaterialColor color;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: DashboardPage._shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: color.shade50,
                child: Icon(icon, size: 16, color: color.shade700),
              ),
              SizedBox(width: 8),
              Text(label, style: TextStyle(color: Colors.black54)),
            ],
          ),
          SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              formatMoney(amount),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
