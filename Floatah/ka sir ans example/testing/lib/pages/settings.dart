import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  blurRadius: 4,
                )
              ]
            ),

            child: ListTile(
              leading: Icon(Icons.person, color: Colors.amber, size: 30,),
              title: Text("Account Settings"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  blurRadius: 4,
                )
              ]
            ),

            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.amber, size: 30,),
              title: Text("Notifications"),
              trailing: Switch(value: (true), onChanged: (_){}),
            ),
          ),
                    SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  blurRadius: 4,
                )
              ]
            ),

            child: ListTile(
              leading: Icon(Icons.shield, color: Colors.amber, size: 30,),
              title: Text("Privacy"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
                    SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  blurRadius: 4,
                )
              ]
            ),

            child: ListTile(
              leading: Icon(Icons.lock, color: Colors.amber, size: 30,),
              title: Text("Security"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
                    SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  blurRadius: 4,
                )
              ]
            ),

            child: ListTile(
              leading: Icon(Icons.language, color: Colors.amber, size: 30,),
              title: Text("Langugae"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
                    SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  blurRadius: 4,
                )
              ]
            ),

            child: ListTile(
              leading: Icon(Icons.dark_mode, color: Colors.amber, size: 30,),
              title: Text("Dark Mode"),
              trailing: Switch(value: (true), onChanged: (_){}),
            ),
          ),
          SizedBox(height: 40,),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)
              ),
              onPressed: (){}, 
              child: Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),))
          ),
        ],
      ),
    );
  }
}