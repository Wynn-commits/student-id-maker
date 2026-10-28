import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            "General",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.dark_mode, color: Colors.black87,),
            title: Text("Dark Mode"),
            trailing: Switch(value: false, onChanged: (val) {}, inactiveTrackColor: Colors.black, inactiveThumbColor: Colors.grey),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blue,),
            title: Text("Notifications"),
            trailing: Switch(value: true, onChanged: (val) {}, activeThumbColor: Colors.white, activeTrackColor: Colors.blueAccent,),
          ),
          Divider(),
          Text(
            "Account",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10,),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.blue,),
            title: Text("Change Password"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.blue,),
            title: Text("Logout"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
