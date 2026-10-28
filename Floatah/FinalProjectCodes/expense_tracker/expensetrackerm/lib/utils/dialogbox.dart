import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/expense_entry.dart';
import 'categories.dart';
import 'format.dart';
import 'mybuttons.dart';

class DialogBox extends StatefulWidget {
  final ExpenseEntry? entry;
  final void Function(ExpenseEntry) onSave;

  const DialogBox({super.key, this.entry, required this.onSave});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late DateTime _date;
  late bool _isIncome;
  late String _category;

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _titleController = TextEditingController(text: entry?.title ?? '');
    _amountController = TextEditingController(
      text: entry == null ? '' : entry.amount.toStringAsFixed(2),
    );
    final now = DateTime.now();
    _date = entry?.date ?? DateTime(now.year, now.month, now.day);
    _isIncome = entry?.isIncome ?? false;
    _category = entry?.category ?? Categories.forType(_isIncome).first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _setType(bool isIncome) {
    setState(() {
      _isIncome = isIncome;
      final options = Categories.forType(isIncome);
      if (!options.contains(_category)) _category = options.first;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Title is required';
    return null;
  }

  String? _validateAmount(String? value) {
    final amount = double.tryParse((value ?? '').trim());
    if (amount == null) return 'Enter a valid amount';
    if (amount <= 0) return 'Amount must be greater than 0';
    if (amount > 100000000) return 'Amount is too large';
    return null;
  }

  void _submit() {
    // stop if naa
    if (!_formKey.currentState!.validate()) return;

    final entry = ExpenseEntry(
      id: widget.entry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      category: _category,
      date: _date,
      isIncome: _isIncome,
    );
    widget.onSave(entry);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        _isEditing ? 'Edit Transaction' : 'New Transaction',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ChoiceChip(
                    label: Text('Expense'),
                    selected: !_isIncome,
                    selectedColor: Colors.red.shade100,
                    onSelected: (_) => _setType(false),
                  ),
                   SizedBox(width: 8),
                  ChoiceChip(
                    label: Text('Income'),
                    selected: _isIncome,
                    selectedColor: Colors.green.shade200,
                    onSelected: (_) => _setType(true),
                  ),
                ],
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title (e.g. Lunch)',
                  border: OutlineInputBorder(),
                ),
                validator: _validateTitle,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₱ ',
                  border: OutlineInputBorder(),
                ),
                validator: _validateAmount,
              ),
              SizedBox(height: 12),
              Text('Category'),
              Wrap(
                spacing: 8,
                children: Categories.forType(_isIncome)
                    .map(
                      (c) => ChoiceChip(
                        label: Text(c),
                        selected: _category == c,
                        selectedColor: Colors.green.shade200,
                        onSelected: (_) => setState(() => _category = c),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.event, size: 20),
                  SizedBox(width: 8),
                  Expanded(child: Text('Date: ${formatDate(_date)}')),
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
