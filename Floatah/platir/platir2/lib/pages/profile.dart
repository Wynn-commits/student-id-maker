import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // Top Profile Card
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("../assets/ako.jpg"),
                ),
                SizedBox(height: 15),
                Text("Erwin Gail O. Orquillano",
                    style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                Text("wynnnn@gmail.com", style: TextStyle(color: Colors.black54)),
                SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[600],
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  onPressed: () {},
                  child: Text("Edit Profile", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          SizedBox(height: 30),

          // Stats Section
          Text("Statistics", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 100,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Icon(Icons.task, color: Colors.amber[700], size: 30),
                    SizedBox(height: 8),
                    Text("12", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Tasks", style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              Container(
                width: 100,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Icon(Icons.message, color: Colors.amber[500], size: 30),
                    SizedBox(height: 8),
                    Text("5", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Messages", style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              Container(
                width: 100,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Icon(Icons.bar_chart, color: Colors.amber[300], size: 30),
                    SizedBox(height: 8),
                    Text("3", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Reports", style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 30),

          // Info Section
          Text("Personal Information", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Card(
            color: Colors.amber[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.phone, color: Colors.amber[700]),
              title: Text("Phone", style: TextStyle(color: Colors.black)),
              subtitle: Text("09754326295", style: TextStyle(color: Colors.black54)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
            ),
          ),
          Card(
            color: Colors.amber[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.date_range, color: Colors.amber[500]),
              title: Text("Birthdate", style: TextStyle(color: Colors.black)),
              subtitle: Text("November 25, 2005", style: TextStyle(color: Colors.black54)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
            ),
          ),
          Card(
            color: Colors.amber[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.location_city, color: Colors.amber[400]),
              title: Text("Location", style: TextStyle(color: Colors.black)),
              subtitle: Text("Purok Dahlia, Baranggay Malaiba, Canlaon City", style: TextStyle(color: Colors.black54)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
            ),
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
              child: Text("Log Out",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
