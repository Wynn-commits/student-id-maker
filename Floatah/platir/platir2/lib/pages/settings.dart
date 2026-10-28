import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // Profile Section
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/ako.jpg"),
                ),
                SizedBox(height: 10),
                Text("Erwin Gail Orquillano", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                Text("wynnnnn@gmail.com", style: TextStyle(color: Colors.grey)),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[600]),
                  onPressed: () {},
                  child: Text("Edit Profile", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          SizedBox(height: 30),

          // Preferences Section
          Text("Preferences", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          SwitchListTile(
            activeThumbColor: Colors.amber[600],
            title: Text("Notifications", style: TextStyle(color: Colors.white)),
            value: true,
            onChanged: (_) {},
          ),
          SwitchListTile(
            activeThumbColor: Colors.amber[600],
            title: Text("Dark Mode", style: TextStyle(color: Colors.white)),
            value: true,
            onChanged: (_) {},
          ),

          SizedBox(height: 30),

          // Security Section
          Text("Security", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.amber[400]),
            title: Text("Change Password", style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
          ListTile(
            leading: Icon(Icons.shield, color: Colors.amber[500]),
            title: Text("Privacy Settings", style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),

          SizedBox(height: 30),

          // Language Section
          Text("General", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.language, color: Colors.amber[300]),
            title: Text("Language", style: TextStyle(color: Colors.white)),
            subtitle: Text("English", style: TextStyle(color: Colors.white70)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),

          SizedBox(height: 40),

          // Logout Button
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              ),
              onPressed: () {},
              child: Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
