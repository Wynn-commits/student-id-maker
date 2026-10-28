import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
   const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Padding(padding: EdgeInsets.all(10)),
          //Container 1

          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.lightBlue,

              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 5,
                  offset: Offset(2, 4)
                )
              ]
            ),

            child: Column(              
              children: [               
              Text("memento mori",style: TextStyle(fontSize: 25, color: Colors.white)),
              Text("we are born to die! don't be so arrogant..."),
              ],
            ),
          ),

          SizedBox(height: 20,),

          //Container 2

          Container(
             height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.lightBlue,

              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  spreadRadius: 5,
                  offset: Offset(2, 4)
                ),
                
                
              ]
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("carpe diem!", style: TextStyle(fontSize: 25, color: Colors.white)),
                          Text("Sieze the day, don't worry about morrow- for today is the day to talk on.", style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

           SizedBox(height: 20,),

          Container(
             height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.lightBlue,

              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 5,
                  offset: Offset(2, 4)
                )
              ]
            ),

              child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("la puertas", style: TextStyle(fontSize: 25, color: Colors.white)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.phone, size: 40,),
                          SizedBox(width: 40,),
                          Icon(Icons.bluetooth, size: 40,),
                          SizedBox(width: 40,),
                          Icon(Icons.ballot, size: 40,),
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
