import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/medicine_service.dart';
import '../utils/empty_state.dart';
import '../utils/medicine_dialog.dart';
import '../utils/medicine_tile.dart';
import '../utils/messages.dart';
import '../utils/mybuttons.dart';
import '../utils/stock_dialog.dart';

/// The medicine records ni dri
class MedicinesPage extends StatefulWidget {
  const MedicinesPage({super.key});

  @override
  State<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  static const _filters = ['All', 'Low stock', 'Near expiry', 'Expired'];

  List<Medicine> _medicines = [];
  String _query = '';
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    _medicines = MedicineService.getMedicines();
  }

  void _refresh() {
    setState(() => _medicines = MedicineService.getMedicines());
  }

  /// sa listahan, pila ka medicines, pila ka low stock, pila ka near expiry, pila ka expired basta mao na
  List<int> get _counts => [
        _medicines.length,
        _medicines.where((m) => m.isLowStock || m.isOutOfStock).length,
        _medicines.where((m) => m.isNearExpiry).length,
        _medicines.where((m) => m.isExpired).length,
      ];

  List<Medicine> get _visible {
    final query = _query.trim().toLowerCase();
    return _medicines.where((m) {
      final matchesSearch = query.isEmpty ||
          m.displayName.toLowerCase().contains(query) ||
          m.category.toLowerCase().contains(query);
      final matchesFilter = switch (_filter) {
        1 => m.isLowStock || m.isOutOfStock,
        2 => m.isNearExpiry,
        3 => m.isExpired,
        _ => true,
      };
      return matchesSearch && matchesFilter;
    }).toList();
  }

  //opens forms
  void _openMedicineDialog({Medicine? medicine}) {
    final isNew = medicine == null;
    showDialog(
      context: context,
      builder: (context) => MedicineDialog(
        medicine: medicine,
        onSave: (saved) async {
          if (isNew) {
            await MedicineService.addMedicine(saved);
          } else {
            await MedicineService.updateMedicine(saved);
          }
          if (!mounted) return;
          _refresh();
          showMessage(this.context, isNew ? 'Medicine added' : 'Medicine updated');
        },
      ),
    );
  }

  void _openStockDialog(Medicine medicine) {
    showDialog(
      context: context,
      builder: (context) => StockDialog(
        medicine: medicine,
        onSave: (isIn, quantity, note) async {
          final ok = await MedicineService.applyStockChange(
            medicine: medicine,
            isIn: isIn,
            quantity: quantity,
            note: note,
          );
          if (!mounted) return;
          _refresh();

          String message;
          if (!ok) {
            message = 'Could not update stock';
          } else if (isIn) {
            message = 'Added $quantity to ${medicine.name}. Stock is now ${medicine.quantity}.';
          } else if (medicine.isOutOfStock) {
            message = '${medicine.name} is now OUT of stock!';
          } else if (medicine.isLowStock) {
            message = '${medicine.name} is running low (${medicine.quantity} left).';
          } else {
            message = 'Removed $quantity from ${medicine.name}. Stock is now ${medicine.quantity}.';
          }
          showMessage(this.context, message);
        },
      ),
    );
  }

  Future<void> _confirmDelete(Medicine medicine) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete medicine?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '"${medicine.displayName}" will be removed from the inventory. '
          'Its stock history will be kept.',
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
    await MedicineService.deleteMedicine(medicine.id);
    if (!mounted) return;
    _refresh();
    showMessage(context, 'Medicine deleted');
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    final counts = _counts;

    return Scaffold(
      appBar: AppBar(title: const Text('Medicines')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openMedicineDialog(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search by name or category',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: List.generate(_filters.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(i == 0 ? _filters[i] : '${_filters[i]} (${counts[i]})'),
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
                    icon: _medicines.isEmpty ? Icons.local_pharmacy : Icons.search_off,
                    message: _medicines.isEmpty
                        ? 'No medicines yet.\nTap the + button to add one.'
                        : 'No medicines match your search or filter.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 80),
                    itemCount: visible.length,
                    itemBuilder: (context, index) {
                      final medicine = visible[index];
                      return MedicineTile(
                        medicine: medicine,
                        onStock: () => _openStockDialog(medicine),
                        onEdit: () => _openMedicineDialog(medicine: medicine),
                        onDelete: () => _confirmDelete(medicine),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
