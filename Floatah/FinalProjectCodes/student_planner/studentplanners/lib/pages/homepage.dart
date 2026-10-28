import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'tasks_page.dart';

/// Holds the bottom navigation bar and switches between the two main pages.
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [DashboardPage(), TasksPage()];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Tasks'),
        ],
      ),
    );
  }
}
