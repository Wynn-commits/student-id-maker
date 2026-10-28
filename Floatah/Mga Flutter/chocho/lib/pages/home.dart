import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Center(
            child: Text("Upper",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
            ),
          ),
          Container(
            width: 200,
            height: 1000,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Icon(Icons.favorite, size: 50, color: Colors.white,),
            
          ),
          Text("Lower", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}
