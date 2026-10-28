import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 150,
            backgroundImage: AssetImage("../assets/ako.jpg"),
          ),
          SizedBox(height: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Erwin Gail O. Orquillano", style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),),
              Text("ErwinGail@gmail.com", style: TextStyle(color: Colors.grey),)
            ],
          ),
          SizedBox(height: 20,),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), onPressed: (){}, child: Text("Edit Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
          SizedBox(height: 30,),
           Container(
            height: 250,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  blurRadius: 4,
                ),
              ],
            ),
            child:
             Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: Icon(Icons.phone, size: 30, color: Colors.amber,),
                  title: Text("Phone"),
                  subtitle: Text("+639876543210"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                SizedBox(height: 10,),
                ListTile(
                  leading: Icon(Icons.date_range, size: 30, color: Colors.amber,),
                  title: Text("Birthdate"),
                  subtitle: Text("January 15, 1995"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                SizedBox(height: 10,),
                ListTile(
                  leading: Icon(Icons.location_city, size: 30, color: Colors.amber,),
                  title: Text("Location"),
                  subtitle: Text("Tapad Silingan"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: EdgeInsets.symmetric(horizontal: 40)), onPressed: (){}, child: Text("Log Out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
        ],
      ),
    );
  }
}