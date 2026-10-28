import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 80, color: const Color.fromARGB(255, 210, 7, 88)),
            SizedBox(height: 30),
            Text("Settings Page", style: TextStyle(fontSize: 24)),
            SizedBox(height: 15),
            Text(" settings"),
          ],
        ),
      ),
    );
  }
}