import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/task_service.dart';

/// Summary screen: counts plus deadlines coming up in the next 7 days.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = TaskService.getAll();
    final total = tasks.length;
    final completed = tasks.where((t) => t.isDone).length;
    final pending = total - completed;
    final overdue = tasks.where((t) => t.isOverdue).length;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextWeek = today.add(Duration(days: 7));
    final upcoming = tasks
        .where((t) =>
            !t.isDone &&
            !t.deadline.isBefore(today) &&
            !t.deadline.isAfter(nextWeek))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Student Planner'), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _StatCard(
                label: 'Total tasks',
                value: total,
                icon: Icons.list_alt,
                color: Colors.blue,
              ),
              _StatCard(
                label: 'Completed',
                value: completed,
                icon: Icons.check_circle_outline,
                color: Colors.green,
              ),
              _StatCard(
                label: 'Pending',
                value: pending,
                icon: Icons.hourglass_empty,
                color: Colors.orange,
              ),
              _StatCard(
                label: 'Overdue',
                value: overdue,
                icon: Icons.warning_amber_rounded,
                color: Colors.red,
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Upcoming deadlines (next 7 days)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (upcoming.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No upcoming deadlines.',
                style: TextStyle(color: Colors.black54),
              ),
            )
          else
            ...upcoming.map(
              (t) => Card(
                color: Colors.white,
                elevation: 1,
                surfaceTintColor: Colors.transparent,
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(Icons.event_note),
                  title: Text(t.title),
                  subtitle: Text(
                    '${t.subject}  •  ${DateFormat('MMM d, y').format(t.deadline)}',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final MaterialColor color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.shade50,
            child: Icon(icon, size: 18, color: color.shade700),
          ),
          SizedBox(height: 6),
          Text(
            '$value',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}