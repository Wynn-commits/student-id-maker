import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import 'categories.dart';
import 'mybuttons.dart';

/// Form dialog used for adding a product (product == null) or editing one.
class ProductDialog extends StatefulWidget {
  final Product? product;
  final void Function(Product) onSave;

  const ProductDialog({super.key, this.product, required this.onSave});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late String _category;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name ?? '');
    _priceController = TextEditingController(
      text: product == null ? '' : product.price.toStringAsFixed(2),
    );
    _descriptionController = TextEditingController(text: product?.description ?? '');
    _category = product?.category ?? Categories.list.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Product name is required';
    return null;
  }

  String? _validatePrice(String? value) {
    final price = double.tryParse((value ?? '').trim());
    if (price == null) return 'Enter a valid price';
    if (price <= 0) return 'Price must be greater than 0';
    if (price > 10000000) return 'Price is too large';
    return null;
  }

  void _submit() {
    // Validation: stops here if any field is invalid.
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      category: _category,
    );
    widget.onSave(product);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        _isEditing ? 'Edit Product' : 'New Product',
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
                decoration: const InputDecoration(
                  labelText: 'Product name',
                  border: OutlineInputBorder(),
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: '₱ ',
                  border: OutlineInputBorder(),
                ),
                validator: _validatePrice,
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
                        selectedColor: Colors.orange.shade200,
                        onSelected: (_) => setState(() => _category = c),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
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
