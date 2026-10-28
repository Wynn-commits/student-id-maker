import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            "Welcome to the Home Page!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text("arlan di ay ni", textAlign: TextAlign.center,), 
          SizedBox(height: 20),
          Text("Home ", textAlign: TextAlign.center,),
          Container(
            width: 200,
            height: 1000,
            decoration: BoxDecoration(
              color: const Color.fromARGB(92, 3, 189, 235),
            ),
            child: Icon(Icons.diamond, size: 90, color: const Color.fromARGB(255, 3, 221, 25),),
          ),
          Text("wlana", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50), textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}
