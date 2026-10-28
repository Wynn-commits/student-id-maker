import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome to Ambot!", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  Text("Here’s the home page", style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
              SizedBox(width: 20),
              Image.asset("../assets/Robot_na_Ume-Elaw-removebg-preview.png", height: 120),
            ],
          ),

          SizedBox(height: 30),

          // Featured Card
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today’s Highlight", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("You have 3 tasks pending and 2 new messages.", style: TextStyle(color: Colors.black87)),
              ],
            ),
          ),

          SizedBox(height: 30),

          // grid
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              Container(
                width: 160,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Icon(Icons.note, color: Colors.amber[700], size: 50),
                    SizedBox(height: 8),
                    Text("Notes", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                width: 160,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.amber[400], size: 50),
                    SizedBox(height: 8),
                    Text("Calendar", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                width: 160,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Icon(Icons.message, color: Colors.amber[600], size: 50),
                    SizedBox(height: 8),
                    Text("Messages", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                width: 160,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Icon(Icons.bar_chart, color: Colors.amber, size: 50),
                    SizedBox(height: 8),
                    Text("Reports", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
