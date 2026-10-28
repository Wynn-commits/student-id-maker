import 'package:flutter/material.dart';
import '../models/expense_entry.dart';
import '../services/expense_service.dart';
import '../utils/dialogbox.dart';
import '../utils/expense_tile.dart';
import '../utils/format.dart';
import '../utils/mybuttons.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  static const _filters = ['All', 'Expenses', 'Income'];

  List<ExpenseEntry> entries = [];
  int _filter = 0; // 0 = All, 1 = Expenses, 2 = Income

  @override
  void initState() {
    super.initState();
    entries = ExpenseService.getAll();
  }

  void _refresh() {
    setState(() => entries = ExpenseService.getAll());
  }

  List<ExpenseEntry> get _visible {
    if (_filter == 1) return entries.where((e) => !e.isIncome).toList();
    if (_filter == 2) return entries.where((e) => e.isIncome).toList();
    return entries;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openDialog({ExpenseEntry? entry}) {
    final isNew = entry == null;
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        entry: entry,
        onSave: (saved) async {
          await ExpenseService.save(saved);
          if (!mounted) return;
          _refresh();
          _showMessage(isNew ? 'Transaction added' : 'Transaction updated');
        },
      ),
    );
  }

  Future<void> _confirmDelete(ExpenseEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete transaction?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '"${entry.title}" (${formatMoney(entry.amount)}) will be permanently removed.',
        ),
        actions: [
          MyButtons(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
          MyButtons(
            text: 'Delete',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ExpenseService.delete(entry.id);
    if (!mounted) return;
    _refresh();
    _showMessage('Transaction deleted');
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;

    return Scaffold(
      appBar: AppBar(title: Text('Transactions'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        child: Icon(Icons.add),
      ),
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
                    selectedColor: Colors.green.shade200,
                    onSelected: (_) => setState(() => _filter = i),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: visible.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 72,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 12),
                          Text(
                            entries.isEmpty
                                ? 'No transactions yet.\nTap the + button to add one.'
                                : 'Nothing to show for this filter.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 80),
                    itemCount: visible.length,
                    itemBuilder: (context, index) {
                      final entry = visible[index];
                      return ExpenseTile(
                        entry: entry,
                        onEdit: () => _openDialog(entry: entry),
                        onDelete: () => _confirmDelete(entry),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
