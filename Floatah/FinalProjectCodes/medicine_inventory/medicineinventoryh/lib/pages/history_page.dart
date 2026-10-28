import 'package:flutter/material.dart';
import '../models/stock_movement.dart';
import '../services/medicine_service.dart';
import '../utils/empty_state.dart';
import '../utils/format.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static const _filters = ['All', 'Stock in', 'Stock out'];

  List<StockMovement> _movements = [];
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    _movements = MedicineService.getMovements();
  }

  List<StockMovement> get _visible {
    if (_filter == 1) return _movements.where((m) => m.isIn).toList();
    if (_filter == 2) return _movements.where((m) => !m.isIn).toList();
    return _movements;
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;

    return Scaffold(
      appBar: AppBar(title: Text('Stock History')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: List.generate(_filters.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_filters[i]),
                    selected: _filter == i,
                    selectedColor: Colors.teal.shade200,
                    onSelected: (_) => setState(() => _filter = i),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: visible.isEmpty
                ? EmptyState(
                    icon: Icons.history,
                    message: _movements.isEmpty
                        ? 'No stock movements yet.\nUse "Stock in/out" on a medicine to record one.'
                        : 'Nothing to show for this filter.',
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(top: 4, bottom: 16),
                    itemCount: visible.length,
                    itemBuilder: (context, index) =>
                        _MovementCard(movement: visible[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MovementCard extends StatelessWidget {
  final StockMovement movement;

  const _MovementCard({required this.movement});

  @override
  Widget build(BuildContext context) {
    final m = movement;
    final color = m.isIn ? Colors.green : Colors.red;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.shade50,
            child: Icon(
              m.isIn ? Icons.arrow_downward : Icons.arrow_upward,
              color: color.shade700,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.medicineName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  m.note.isEmpty ? (m.isIn ? 'Stock in' : 'Stock out') : m.note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black54),
                ),
                Text(
                  formatDateTime(m.date),
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${m.isIn ? '+' : '-'}${m.quantity}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color.shade700,
                ),
              ),
              Text(
                'Balance: ${m.balanceAfter}',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
