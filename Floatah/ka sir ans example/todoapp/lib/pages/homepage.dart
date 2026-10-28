import 'package:flutter/material.dart';
import 'package:todoapp/utils/dialogbox.dart';
import 'package:todoapp/utils/todotile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final _controller = TextEditingController();

  List toDoList = [
    [
      "dili mo konsider!", //[0][0]
      false, //[0][1]
    ], // 0
    ["mangulata'g tabi-an", false], //1
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

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
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
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text("Avo"),
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
            deleteFunction: () => deleteTask(index),
          );
        },
      ),
    );
  }
}
