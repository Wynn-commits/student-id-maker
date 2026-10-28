import 'package:flutter/material.dart';
import 'package:inventorymanagement/utils/mybuttons.dart';

class StockDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String productName;
  final int currentQuantity;
  final String type; // "in" or "out"
  final VoidCallback onSave;
  final VoidCallback onCancel;

  StockDialog({
    super.key,
    required this.formKey,
    required this.controller,
    required this.productName,
    required this.currentQuantity,
    required this.type,
    required this.onSave,
    required this.onCancel,
  });

  String? checkAmount(String? value) {
    int? n = int.tryParse((value ?? "").trim());
    if (n == null || n <= 0) {
      return "Enter a number greater than 0";
    }
    // you cannot take more than what is stock
    if (type == "out" && n > currentQuantity) {
      return "Only $currentQuantity in stock";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool isIn = type == "in";

    return AlertDialog(
      backgroundColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isIn ? Icons.add_circle : Icons.remove_circle,
                  color: isIn ? Colors.green.shade800 : Colors.orange.shade900,
                ),
                SizedBox(width: 8),
                Text(
                  isIn ? "Stock In" : "Stock Out",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(productName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Current stock: $currentQuantity"),
            SizedBox(height: 16),
            Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: checkAmount,
              ),
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
    );
  }
}
