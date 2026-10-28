import 'package:flutter/material.dart';
import 'package:inventorymanagement/utils/mybuttons.dart';

// The dialog used for BOTH adding and editing a product.
class DialogBox extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController categoryController;
  final TextEditingController quantityController;
  final TextEditingController minStockController;
  final TextEditingController priceController;
  final bool quantityEnabled;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.title,
    required this.formKey,
    required this.nameController,
    required this.categoryController,
    required this.quantityController,
    required this.minStockController,
    required this.priceController,
    required this.quantityEnabled,
    required this.onSave,
    required this.onCancel,
  });

  // the same white rounded look for every text field
  InputDecoration fieldDecoration(String label, {String? helper}) {
    return InputDecoration(
      labelText: label,
      helperText: helper,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  // ---- validators: return an error message, or null when the value is OK ----

  String? requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    return null;
  }

  String? wholeNumber(String? value) {
    int? n = int.tryParse((value ?? "").trim());
    if (n == null) {
      return "Enter a whole number";
    }
    if (n < 0) {
      return "Cannot be negative";
    }
    return null;
  }

  String? priceNumber(String? value) {
    double? n = double.tryParse((value ?? "").trim());
    if (n == null) {
      return "Enter a valid price";
    }
    if (n < 0) {
      return "Cannot be negative";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: fieldDecoration("Product name"),
                validator: requiredText,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: categoryController,
                textCapitalization: TextCapitalization.sentences,
                decoration: fieldDecoration("Category"),
                validator: requiredText,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: quantityController,
                enabled: quantityEnabled,
                keyboardType: TextInputType.number,
                decoration: fieldDecoration(
                  "Quantity",
                  helper: quantityEnabled ? null : "Use Stock In / Stock Out to change this",
                ),
                validator: wholeNumber,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: minStockController,
                keyboardType: TextInputType.number,
                decoration: fieldDecoration(
                  "Low stock level",
                  helper: "Warn me when stock is at or below this",
                ),
                validator: wholeNumber,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: fieldDecoration("Price"),
                validator: priceNumber,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButtons(
                    text: "Save",
                    color: Colors.black87,
                    textColor: Colors.white,
                    onPressed: onSave,
                  ),
                  SizedBox(width: 10),
                  MyButtons(text: "Cancel", onPressed: onCancel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
