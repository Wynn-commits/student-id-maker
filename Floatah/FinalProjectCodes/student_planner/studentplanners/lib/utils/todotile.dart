import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TodoTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
  });

  /// Color of the stripe on the left, based on priority.
  MaterialColor get _priorityColor {
    switch (task.priority) {
      case 'High':
        return Colors.red;
      case 'Low':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('MMM d, y').format(task.deadline);
    final stripColor = _priorityColor.shade400;
    final dateColor = task.isOverdue ? Colors.red.shade700 : Colors.black54;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored stripe on the left shows the priority at a glance.
              Container(width: 6, color: stripColor),
              Checkbox(
                value: task.isDone,
                onChanged: onChanged,
                activeColor: Colors.black87,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: task.isDone ? Colors.black45 : Colors.black87,
                          decoration:
                              task.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        task.subject,
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.event, size: 14, color: dateColor),
                          const SizedBox(width: 4),
                          Text(
                            task.isOverdue ? '$dateText • Overdue' : dateText,
                            style: TextStyle(
                              fontSize: 13,
                              color: dateColor,
                              fontWeight: task.isOverdue
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(onPressed: onEdit, icon: Icon(Icons.edit_outlined)),
              IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}