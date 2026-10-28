import 'package:flutter/material.dart';
import 'package:platir1/pages/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IndexPage(),
    );
  }
}











// notes:

// So ang sizedbox kay for spacing lang siya, no color or decoration allowed.
// Pero ang container naay naya height, width, color, basta tanan yata

// borderRadius: BorderRadius.circular(12), - mahimong rounded corners

// shadow:
//   blurRadius: 8, // soften the shadow
//   spreadRadius: 2, // extend the shadow
//   offset: Offset(2, 4), // moves shadow (x,y)

// Paddings and margins:
// EdgeInsets.all(8) -- 8 pixels on all sides.
// EdgeInsets.symmetric(horizontal: 8) -- 8 pixels left & right only.
// EdgeInsets.only(top: 8, left: 16) -- para sa specific sides

//  In ListTile:
//   ListTile(
//   leading: Icon(Icons.folder),          // left side
//   title: Text("My Files"),              // main text
//   subtitle: Text("Tap to open"),        // smaller text below
//   trailing: Icon(Icons.arrow_forward),  // right side
// )

//  Switch:
// Switch(
//   value: true,
//   onChanged: (_) {},
// )
// value: true -- the switch is currently ON.
// onChanged: (_) {} -- callback function that runs when the user toggles the switch. 
// The underscore _ is just a placeholder for the new boolean value (true or false).