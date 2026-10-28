import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  "assets/bairan.jpg",
                ),
              ),
              SizedBox(height: 20),
              Text("Name: agraviador", style: TextStyle(fontSize: 20)),
              Text("Age: 21", style: TextStyle(fontSize: 20)),
              Text("Address:  CPSU,  ", style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}