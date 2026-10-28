import 'package:arlan/home.dart';
import 'package:arlan/profile.dart';
import 'package:arlan/settings.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  int _selectedIndex = 0;

  void bottomNavOnPressed(int index){
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 251, 6, 161),
        centerTitle: true,
        title: Text("Arlan  ", style: TextStyle(color: const Color.fromARGB(255, 92, 252, 6), fontSize: 25, fontWeight: FontWeight.bold),),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 1, 141),
        currentIndex: _selectedIndex,
        onTap: bottomNavOnPressed,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ]),

        body: _pages[_selectedIndex],
    );
  }
}