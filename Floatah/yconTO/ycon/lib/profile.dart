import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
   const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage("assets/Ycon.jpg"),
            ),
            Text(
              "Connie S. Layar",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              "18 yrs. old",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 21,
                fontWeight: FontWeight.bold
              ),
            ),

            Text(
              "Bachelor of Science in Information Technology",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              "Tigbon, Calatrava, Negros Occidental",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}