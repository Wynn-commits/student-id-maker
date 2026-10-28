import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String name;
  final String category;
  final int quantity;
  final int minStock;
  final double price;
  final VoidCallback onStockIn;
  final VoidCallback onStockOut;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  ProductTile({
    super.key,
    required this.name,
    required this.category,
    required this.quantity,
    required this.minStock,
    required this.price,
    required this.onStockIn,
    required this.onStockOut,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    String status = "In stock";
    MaterialColor statusColor = Colors.green;
    if (quantity == 0) {
      status = "Out of stock";
      statusColor = Colors.red;
    } else if (quantity <= minStock) {
      status = "Low stock";
      statusColor = Colors.orange;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.yellow,
                  child: Text(
                    name[0].toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "$category  |  ₱${price.toStringAsFixed(2)}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "$quantity",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: statusColor.shade800,
                      ),
                    ),
                    Text("min $minStock", style: TextStyle(fontSize: 11, color: Colors.black45)),
                  ],
                ),
              ],
            ),
            Divider(height: 24),

            // bottom part: status label and the action buttons
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor.shade900,
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  tooltip: "Stock in",
                  visualDensity: VisualDensity.compact,
                  onPressed: onStockIn,
                  icon: Icon(Icons.add_circle, color: Colors.green.shade700),
                ),
                IconButton(
                  tooltip: "Stock out",
                  visualDensity: VisualDensity.compact,
                  onPressed: onStockOut,
                  icon: Icon(Icons.remove_circle, color: Colors.orange.shade800),
                ),
                IconButton(
                  tooltip: "Edit",
                  visualDensity: VisualDensity.compact,
                  onPressed: onEdit,
                  icon: Icon(Icons.edit, color: Colors.black54),
                ),
                IconButton(
                  tooltip: "Delete",
                  visualDensity: VisualDensity.compact,
                  onPressed: onDelete,
                  icon: Icon(Icons.delete, color: Colors.red.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
