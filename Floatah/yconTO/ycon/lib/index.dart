
import 'package:flutter/material.dart';
import 'package:ycon/homepage.dart';
import 'package:ycon/profile.dart';
import 'package:ycon/settings.dart';

class IndexPage extends StatefulWidget {
   const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

   int _selectedIndex = 0;


   void bottomNavBarTapped (int index){

    setState(() {
      _selectedIndex = index;

    });
   }



   final List _pages = [
  
    HomePage(), //index 0

    SettingsPage(), //index 1

    ProfilePage(),// index 2
   ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        title: Text("'_'Avoqaedoo'_'"),

        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications, color: Colors.black87,))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.greenAccent,
        currentIndex:_selectedIndex,
        onTap: bottomNavBarTapped,
        items: [
                //1st ITEM
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black87,),
            label: "Home"
            ),

            //2nd ITEM
            BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.black87,),
            label: "Settings"
            ),

            //3rd ITEM
            BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black87,),
            label: "Profile"
            ),
        ]
        ),

        body: _pages[_selectedIndex],


    );
  }
}