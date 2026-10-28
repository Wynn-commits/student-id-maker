import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/medicine.dart';
import 'categories.dart';
import 'format.dart';
import 'mybuttons.dart';


class MedicineDialog extends StatefulWidget {
  final Medicine? medicine;
  final void Function(Medicine) onSave;

  const MedicineDialog({super.key, this.medicine, required this.onSave});

  @override
  State<MedicineDialog> createState() => _MedicineDialogState();
}

class _MedicineDialogState extends State<MedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _strengthController;
  late final TextEditingController _quantityController;
  late final TextEditingController _minStockController;
  late String _category;
  late DateTime _expiryDate;

  bool get _isEditing => widget.medicine != null;

  @override
  void initState() {
    super.initState();
    final medicine = widget.medicine;
    _nameController = TextEditingController(text: medicine?.name ?? '');
    _strengthController = TextEditingController(text: medicine?.strength ?? '');
    _quantityController = TextEditingController();
    _minStockController = TextEditingController(
      text: medicine == null ? '10' : '${medicine.minStock}',
    );
    _category = medicine?.category ?? Categories.list.first;
    final now = DateTime.now();
    _expiryDate = medicine?.expiryDate ?? DateTime(now.year + 1, now.month, now.day);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _strengthController.dispose();
    _quantityController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _expiryDate = picked);
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Medicine name is required';
    return null;
  }

  String? _validateWholeNumber(String? value, String label) {
    final number = int.tryParse((value ?? '').trim());
    if (number == null) return 'Enter $label';
    if (number > 1000000) return 'Number is too large';
    return null;
  }

  void _submit() {
    // Vstop validation
    if (!_formKey.currentState!.validate()) return;

    final existing = widget.medicine;
    final medicine = Medicine(
      id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      strength: _strengthController.text.trim(),
      category: _category,
      quantity: existing?.quantity ?? int.parse(_quantityController.text.trim()),
      minStock: int.parse(_minStockController.text.trim()),
      expiryDate: _expiryDate,
    );
    widget.onSave(medicine);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        _isEditing ? 'Edit Medicine' : 'New Medicine',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Medicine name',
                  border: OutlineInputBorder(),
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _strengthController,
                decoration: const InputDecoration(
                  labelText: 'Strength / size (optional, e.g. 500mg)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Category'),
              Wrap(
                spacing: 8,
                children: Categories.list
                    .map(
                      (c) => ChoiceChip(
                        label: Text(c),
                        selected: _category == c,
                        selectedColor: Colors.teal.shade200,
                        onSelected: (_) => setState(() => _category = c),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              if (_isEditing)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Current stock: ${widget.medicine!.quantity}\n'
                    'To change it, use "Stock in/out" on the medicine card.',
                    style: const TextStyle(color: Colors.black54),
                  ),
                )
              else
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Starting stock (quantity)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _validateWholeNumber(value, 'the starting stock'),
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _minStockController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Low-stock level',
                  helperText: 'Warn me when stock is at or below this',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _validateWholeNumber(value, 'a low-stock level'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.event, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Expiry: ${formatDate(_expiryDate)}')),
                  MyButtons(text: 'Change', onPressed: _pickDate),
                ],
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
