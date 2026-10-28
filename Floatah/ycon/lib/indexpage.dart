import 'package:flutter/material.dart';
import 'package:ycon/homepage.dart';
import 'package:ycon/profilepage.dart';
import 'package:ycon/settingspage.dart';

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
 HomePage(),
 SettingsPage(),
 ProfilePage(),
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          "avoquadoo",
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        currentIndex: _selectedIndex,
        onTap: bottomNavBarTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),

      drawer: Drawer(),

      body: _pages[_selectedIndex],
    );
  
  }
}