import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.all(10)),

          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,

              boxShadow: [
               BoxShadow(
                blurRadius: 6,
                offset: Offset(2, 4),
               ),
              ],             
              
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("memento mori", style: TextStyle(fontSize: 25, color: Colors.white),),
                Text("we are born to die, don't be so arrogant..."),
              ],
            ),
          ),
          SizedBox(height: 20,),

          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,

              boxShadow: [
               BoxShadow(
                blurRadius: 6,
                offset: Offset(2, 4),
               ),
              ],             
              
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("memento mori", style: TextStyle(fontSize: 25, color: Colors.white),),
                Text("we are born to die, don't be so arrogant..."),
              ],
            ),
          ),
          SizedBox(height: 20,),

          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,

              boxShadow: [
               BoxShadow(
                blurRadius: 6,
                offset: Offset(2, 4),
               ),
              ],             
              
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Text("la puertas", style: TextStyle(fontSize: 25, color: Colors.white),),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Center(
                  child: Row(                                                 
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.ballot)),
                SizedBox(width: 40,),
                IconButton(onPressed: (){}, icon: Icon(Icons.phone)),
                SizedBox(width: 40,),
                IconButton(onPressed: (){}, icon: Icon(Icons.bluetooth)),
              ],
            ),
          ),
                ],
          ),
              ],
      ),
    ),
        ],
      )
    );
  }
}