import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../utils/dialogbox.dart';
import '../utils/mybuttons.dart';
import '../utils/todotile.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    tasks = TaskService.getAll(); // load saved tasks from Hive
  }

  void _refresh() {
    setState(() => tasks = TaskService.getAll());
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _toggleDone(Task task, bool? value) async {
    task.isDone = value ?? false;
    await TaskService.save(task);
    _refresh();
  }

  /// Opens the form: empty for a new task, prefilled when editing.
  void _openDialog({Task? task}) {
    final isNew = task == null;
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        task: task,
        onSave: (saved) async {
          await TaskService.save(saved);
          if (!mounted) return;
          _refresh();
          _showMessage(isNew ? 'Task added' : 'Task updated');
        },
      ),
    );
  }

  Future<void> _confirmDelete(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green,
        title: Text('Delete task?'),
        content: Text('"${task.title}" will be permanently removed.'),
        actions: [
          MyButtons(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
          MyButtons(
            text: 'Delete',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await TaskService.delete(task.id);
    if (!mounted) return;
    _refresh();
    _showMessage('Task deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(title: const Text('My Tasks'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        child: Icon(Icons.add),
      ),
      body: tasks.isEmpty? Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No tasks yet.\nTap the + button to add one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 80),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TodoTile(
                  task: task,
                  onChanged: (value) => _toggleDone(task, value),
                  onEdit: () => _openDialog(task: task),
                  onDelete: () => _confirmDelete(task),
                );
              },
            ),
    );
  }
}
