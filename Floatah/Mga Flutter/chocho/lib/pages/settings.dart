import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            children: [
              Icon(Icons.settings, size: 60, color: Colors.green),
              Text("about")
            ],
          ),
        ),
      ),
    );
  }
}