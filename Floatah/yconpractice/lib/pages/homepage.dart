import 'package:flutter/material.dart';
import 'package:yconpractice/utils/dialogbox.dart';
import 'package:yconpractice/utils/todotile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final _controller = TextEditingController();

  List toDoList = [
    [
      "Wake up in the afternoon", //[0][0]
      false, //[0][1]
    ], // 0
    ["Eat Milk, and Drink Rice", false], //1
  ];

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  void saveNewTask(){
    setState(() {
      toDoList.add([_controller.text, false]);
      Navigator.of(context).pop();
      _controller.clear();
   
    }
    
    );
  }


  void addNewTask(){
    showDialog(context: context, builder:(context) {
      return DialogBox(
        controller: _controller,
        onSave: saveNewTask ,
        onCancel:() => Navigator.of(context).pop(),
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text("TODO App"),
        centerTitle: true,

        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addNewTask,
        child: Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: toDoList[index][0],
            taskCompleted: toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
          );
        },
      ),
    );
  }
}
