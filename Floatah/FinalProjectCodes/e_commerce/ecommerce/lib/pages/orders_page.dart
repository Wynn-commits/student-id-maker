import 'package:flutter/material.dart';
import '../models/shop_order.dart';
import '../services/shop_service.dart';
import '../utils/empty_state.dart';
import '../utils/format.dart';

/// Order history. 
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<ShopOrder> _orders = [];

  @override
  void initState() {
    super.initState();
    _orders = ShopService.getOrders(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: _orders.isEmpty
          ? const EmptyState(
              icon: Icons.receipt_long_outlined,
              message: 'No orders yet.\nOrders you place will show up here.',
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _orders.length,
              itemBuilder: (context, index) => _OrderCard(order: _orders[index]),
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final ShopOrder order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange.shade100,
            child: Icon(Icons.receipt_long, color: Colors.orange.shade800),
          ),
          title: Text(
            'Order ${order.shortId}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${formatDateTime(order.date)}\n${formatMoney(order.total)}  •  Placed',
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...order.lines.map(
              (l) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${l.quantity} × ${l.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(formatMoney(l.subtotal)),
                  ],
                ),
              ),
            ),
            const Divider(),
            Text('Deliver to: ${order.customerName}, ${order.phone}'),
            const SizedBox(height: 2),
            Text(order.address),
            const SizedBox(height: 6),
            Text(
              'Payment: ${order.payment}',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
