import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/medicine.dart';
import 'mybuttons.dart';

class StockDialog extends StatefulWidget {
  final Medicine medicine;
  final void Function(bool isIn, int quantity, String note) onSave;

  const StockDialog({super.key, required this.medicine, required this.onSave});

  @override
  State<StockDialog> createState() => _StockDialogState();
}

class _StockDialogState extends State<StockDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isIn = true;

  @override
  void dispose() {
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String? _validateQuantity(String? value) {
    final quantity = int.tryParse((value ?? '').trim());
    if (quantity == null) return 'Enter a quantity';
    if (quantity <= 0) return 'Quantity must be at least 1';
    if (quantity > 1000000) return 'Number is too large';
    // A stock-out can never be more than what is on hand.
    if (!_isIn && quantity > widget.medicine.quantity) {
      return 'Only ${widget.medicine.quantity} in stock';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSave(
      _isIn,
      int.parse(_quantityController.text.trim()),
      _noteController.text.trim(),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.medicine;

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Update Stock', style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(m.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                'Current stock: ${m.quantity}',
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Stock in'),
                    selected: _isIn,
                    selectedColor: Colors.green.shade200,
                    onSelected: (_) => setState(() => _isIn = true),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Stock out'),
                    selected: !_isIn,
                    selectedColor: Colors.red.shade100,
                    onSelected: (_) => setState(() => _isIn = false),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                validator: _validateQuantity,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: _isIn ? 'e.g. Delivery from supplier' : 'e.g. Dispensed, expired',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        MyButtons(text: 'Save', onPressed: _submit),
        MyButtons(text: 'Cancel', onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }
}
