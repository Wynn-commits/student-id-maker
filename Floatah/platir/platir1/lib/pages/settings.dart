import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView( 
        padding: EdgeInsets.all(15),
        children: [

          //Account settings na container
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
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
              leading: Icon(Icons.person, color: Colors.green,),
              title: Text("Account Settings"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16,),
            ),
          ),

          //Notif Section
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
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
              leading: Icon(Icons.notifications, color: Colors.green,),
              title: Text("Notifications"),
              trailing: Switch(value: true, onChanged: (_){}),
            ),
          ),

          //Privacy siksyon
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
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
              leading: Icon(Icons.shield, color: Colors.green),
              title: Text("Privacy"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16,),
            ),
          ),

          //Security siksyon
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 6,
                  offset: Offset(2, 4),
                ),
              ]
            ),
            child: ListTile(
              leading: Icon(Icons.lock, color: Colors.green,),
              title: Text("Security"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16,),
            ),
          ),

          //Language part
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
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
              leading: Icon(Icons.language, color: Colors.green,),
              title: Text("Language"),
              trailing: Text("English"),
            ),
          ),

          //Lightordarkmode
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 6,
                  offset: Offset(2, 4)
                ),
              ]
            ),
            child: ListTile(
              leading: Icon(Icons.dark_mode, color: Colors.green,),
              title: Text("Dark Mode"),
              trailing: Switch(value: false, onChanged: (_){}),
            ),
          ),

          //HelpandsupportSection
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 6,
                  offset: Offset(2, 4)
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.help, color: Colors.green,),
              title: Text("Help & Support"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16,),
            ),
          ),

          //AboutSectionLast
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
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
              leading: Icon(Icons.info, color: Colors.green,),
              title: Text("About"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16,),
            ),
          ),

          SizedBox(height: 30,),

          //Log Out
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: (){}, 
              child:  Text("Log out", style: TextStyle(color: Colors.white, fontSize: 16),)
            ),
          )

        ],
      ),
    );
  }
}