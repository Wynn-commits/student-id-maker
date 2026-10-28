import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[700],
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome textss
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to Ambot!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Here’s the home page",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
             SizedBox(width: 20),
              // Robot image
              Image.asset(
                "../assets/Robot_na_Ume-Elaw-removebg-preview.png",
                height: 120,
              ),
            ],
          ),

         SizedBox(height: 20),

          // Profile na may quick actions
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.amber[700],
                  child: Icon(Icons.person, color: Colors.black),
                ),
               SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Erwin", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Online", style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.settings, color: Colors.white),
                ),
              ],
            ),
          ),

         SizedBox(height: 18),

          // Search bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
               Icon(Icons.search, color: Colors.white70),
               SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search tasks, messages, reports",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.mic, color: Colors.white70),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Featuree Card 
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today’s Highlight",
                  style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "You have 3 tasks pending and 2 new messages.",
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Quick stats row (inline, no extra classes)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tasks", style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 8),
                      Text("3", style: TextStyle(color: Colors.amber[700], fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Messages", style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 8),
                      Text("2", style: TextStyle(color: Colors.amber[500], fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Projects", style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 8),
                      Text("5", style: TextStyle(color: Colors.amber[300], fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          SizedBox(
            height: 150,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Card 1
                  Container(
                    width: 260,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.timer, color: Colors.white, size: 28),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Focus Mode", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              SizedBox(height: 6),
                              Text("2 hours left", style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  // Card 2
                  Container(
                    width: 260,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.flag, color: Colors.white, size: 28),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Text("Daily Goals", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              SizedBox(height: 6),
                              Text("4/6 completed", style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // grid
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              Container(
                width: 160,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Icon(Icons.note, color: Colors.amber[700], size: 50),
                    SizedBox(height: 8),
                    Text("Notes", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                width: 160,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.amber[400], size: 50),
                    SizedBox(height: 8),
                    Text("Calendar", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                width: 160,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Icon(Icons.message, color: Colors.amber[600], size: 50),
                    SizedBox(height: 8),
                    Text("Messages", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                width: 160,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Icon(Icons.bar_chart, color: Colors.amber, size: 50),
                    SizedBox(height: 8),
                    Text("Reports", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                width: 160,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Icon(Icons.person_search, color: Colors.amber[300], size: 50),
                    SizedBox(height: 8),
                    Text("Contacts", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                width: 160,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Icon(Icons.settings, color: Colors.amber[200], size: 50),
                   SizedBox(height: 8),
                   Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),

         SizedBox(height: 24),

          // Recent activity (inline)
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Text("Recent Activity", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
               SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: Colors.amber),
                    SizedBox(width: 10),
                    Expanded(child: Text("Meeting with design team", style: TextStyle(color: Colors.white))),
                    Text("2h ago", style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
               Divider(color: Colors.white12),
                Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: Colors.amber),
                    SizedBox(width: 10),
                    Expanded(child: Text("New message from Anna", style: TextStyle(color: Colors.white))),
                    Text("4h ago", style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
               Divider(color: Colors.white12),
                Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: Colors.amber),
                    SizedBox(width: 10),
                    Expanded(child: Text("Report exported", style: TextStyle(color: Colors.white))),
                    Text("Yesterday", style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

         SizedBox(height: 30),

          // Bottom action row (inline)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700]),
                onPressed: () {},
                icon: Icon(Icons.add),
                label: Text("New Task"),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white24),
                ),
                onPressed: () {},
                icon: Icon(Icons.share, color: Colors.white),
                label: Text("Share", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),

         SizedBox(height: 40),
        ],
      ),
    );
  }
}
