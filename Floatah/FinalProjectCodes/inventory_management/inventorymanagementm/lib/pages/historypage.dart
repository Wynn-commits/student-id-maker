import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    //newest record first
    final records = Hive.box("history").values.toList().reversed.toList();

    return Scaffold(
      appBar: AppBar(title: Text("Stock History")),
      body: records.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 70, color: Colors.black38),
                  SizedBox(height: 12),
                  Text(
                    "No stock movements yet.\nUse Stock In / Stock Out on a product.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final r = records[index];
                bool isIn = r["type"] == "in";

                // "2026-10-28T14:30:00.000" becomes "2026-10-28 14:30"
                final date = r["date"].toString().substring(0, 16).replaceFirst("T", " ");

                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: isIn ? Colors.green.shade100 : Colors.red.shade100,
                        child: Icon(
                          isIn ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isIn ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${r['productName']}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "${isIn ? 'Stock in' : 'Stock out'}  |  $date",
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${isIn ? '+' : '-'}${r['quantity']}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isIn ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
