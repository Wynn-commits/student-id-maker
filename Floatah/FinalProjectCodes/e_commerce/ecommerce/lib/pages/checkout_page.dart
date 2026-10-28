import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/cart_line.dart';
import '../services/shop_service.dart';
import '../utils/format.dart';
import '../utils/mybuttons.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const _paymentMethods = ['Cash on Delivery', 'GCash', 'Credit Card'];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _payment = _paymentMethods.first;

  late final List<CartLine> _lines;
  late final double _total;

  @override
  void initState() {
    super.initState();
    _lines = ShopService.getCartLines();
    _total = _lines.fold<double>(0, (sum, l) => sum + l.subtotal);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required';
    return null;
  }

  String? _validatePhone(String? value) {
    final digits = (value ?? '').trim();
    if (digits.length < 7 || digits.length > 15) {
      return 'Enter a valid phone number (7 to 15 digits)';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().length < 5) {
      return 'Enter your complete delivery address';
    }
    return null;
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final order = await ShopService.placeOrder(
      customerName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      payment: _payment,
    );
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Order placed!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Order ${order.shortId} (${formatMoney(order.total)}) was placed '
          'successfully.\nYou can see it in the Orders tab.',
        ),
        actions: [
          MyButtons(text: 'OK', onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop(); // 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              'Order summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  ..._lines.map(
                    (l) => Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${l.quantity} × ${l.product.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(formatMoney(l.subtotal)),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        formatMoney(_total),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Delivery details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Full name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              validator: _validateName,
            ),
           SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Phone number',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              validator: _validatePhone,
            ),
           SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Delivery address',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              validator: _validateAddress,
            ),
             SizedBox(height: 20),
             Text(
              'Payment method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: _paymentMethods
                  .map(
                    (m) => ChoiceChip(
                      label: Text(m),
                      selected: _payment == m,
                      selectedColor: Colors.orange.shade200,
                      onSelected: (_) => setState(() => _payment = m),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 4),
            Text(
              'Simulation only. No real payment is processed.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
             SizedBox(height: 24),
            FilledButton(
              onPressed: _placeOrder,
              child: Text('Place order'),
            ),
          ],
        ),
      ),
    );
  }
}
