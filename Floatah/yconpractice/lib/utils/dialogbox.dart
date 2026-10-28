import 'package:flutter/material.dart';
import 'package:yconpractice/utils/mybuttons.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;
  DialogBox({super.key, required this.controller, required this. onSave, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow,
      content: Container(
        height: 120,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller:controller ,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               MyButtons(text: "Save", onPressed:onSave),
               SizedBox(width: 10,),
               MyButtons(text: "Cancel", onPressed:onCancel),
              ],
            )


          ],
        ),
      ),
    );
  }
}
