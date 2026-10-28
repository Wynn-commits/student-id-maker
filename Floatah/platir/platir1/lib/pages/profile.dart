import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          CircleAvatar(
            radius: 150,
            backgroundImage: AssetImage("assets/ako.jpg"),
          ),
          SizedBox(height: 15),
          Text("Erwin Gail O. Orquillano", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          Text("ErwinGail@gmail.com", style: TextStyle(color: Colors.grey),),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(20),
              )
            ),
            onPressed: (){}, 
            child: Text("Edit Profile", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),)
          ),

          SizedBox(height: 20),

          //About nako section
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 6,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: ListTile(
              title: Text("About me"),
              subtitle: Text("Passionate app developer with a love for Flutter (Hates actually) and creating amazing user experiences!"),
            ),
          ),

          SizedBox(height: 20),

          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 6,
                  offset: Offset(2, 4),
                )
              ]
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.green,),
                  title: Text("Phone"),
                  subtitle: Text("+639876543210"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16,),
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.green,),
                  title: Text("Birthdate"),
                  subtitle: Text("January 15, 1995"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16,),
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.green,),
                  title: Text("Location"),
                  subtitle: Text("Tapad Silingan"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16,),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          //Skills Section
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 6,
                  offset: Offset(2, 4),
                )
              ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                 spacing: 10,
                  children: [
                    Column(
                      children: [
                        Chip(label: Text("C++", style: TextStyle(color: Colors.white),), backgroundColor: Colors.purple.shade500,),
                        Chip(label: Text("Java", style: TextStyle(color: Colors.white),), backgroundColor: Colors.blue.shade500,),
                        Chip(label: Text("Python", style: TextStyle(color: Colors.white),), backgroundColor: Colors.orange.shade500,),
                      ],
                    ),
                    Column(
                      children: [
                        Chip(label: Text("JavaScript", style: TextStyle(color: Colors.white),), backgroundColor: Colors.orange.shade500,),
                        Chip(label: Text("Vue", style: TextStyle(color: Colors.white),), backgroundColor: Colors.purple.shade500,),
                        Chip(label: Text("React", style: TextStyle(color: Colors.white),), backgroundColor: Colors.blue.shade500,),
                      ],
                    ),
                    Column(
                      children: [
                        Chip(label: Text("Angular", style: TextStyle(color: Colors.white),), backgroundColor: Colors.blue.shade500,),
                        Chip(label: Text("Supabase", style: TextStyle(color: Colors.white),), backgroundColor: Colors.orange.shade500,),
                        Chip(label: Text("Firebase", style: TextStyle(color: Colors.white),), backgroundColor: Colors.purple.shade500,),
                      ],
                    ),
                  ],
                ),
              ],
            ), 
          ),

          SizedBox(height: 20),

          //Log Out
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: (){}, 
              child: Text("Log out", style: TextStyle(color: Colors.white, fontSize: 16),),
            ),
          )

        ],
      ),
    );
  }
}