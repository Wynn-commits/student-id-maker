import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
            //Headline?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(padding: EdgeInsets.all(10)),
                Column(
                  children: [
                    Text("Welcome to Ambot!", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
                    Text("This is my Home Page!", style: TextStyle(color: Colors.grey),),
                  ],
                ),  
                Image.asset("../assets/Robot_na_Ume-Elaw-removebg-preview.png", height: 200,),
              ],
            ),

            //Quick Action na section
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 8, 
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  )
                ]
              ),
              
              //Subheader
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Subheader
                  Text("Quick Actions", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
                  SizedBox(height: 30),

                  //Contents ari sa Quick Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 100,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(2, 4)
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.folder, color: Colors.purple, size: 40),
                            Text("Scan Files"),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(2, 4)
                            ),
                          ],
                        ),

                        child: Column(
                          children: [
                            Icon(Icons.cloud_upload, color: Colors.green, size: 40),
                            Text("Upload"),
                          ],
                        ),
                      ),

                      Container(
                        width: 100,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(2, 4)
                            )
                          ]
                        ),

                        child: Column(
                          children: [
                            Icon(Icons.share, color: Colors.blue, size: 40),
                            Text("Share"),
                        ] ,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ),

            SizedBox(height: 30),

            //Latest Updates Sections
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                   color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Latest Updates",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        Column(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 40),
                            Text("Feature X"),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 40),
                            Text("Fix bug Y"),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.new_releases, color: Colors.green, size: 40),
                            Text("Update Z"),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
          ),

          SizedBox(height: 30),


          //ambot
          Container(
            height: 300,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                   color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("I ran out of ideas.", style: TextStyle(fontSize: 25),)
                ],
              ),
          ),

          ],
      ),
    );
  }
}