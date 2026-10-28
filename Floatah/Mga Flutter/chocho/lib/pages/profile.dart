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
                  "assets/choo.jpg",
                ),
              ),
              SizedBox(height: 20),
              Text("Name: Arnrie Burnt R. Toledo ", style: TextStyle(fontSize: 20)),
              Text("Age: 22 yrs old", style: TextStyle(fontSize: 20)),
              Text("Address: Endrina Street, San Carlos City", style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}