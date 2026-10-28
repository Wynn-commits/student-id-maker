import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import 'mybuttons.dart';

/// Form dialog used for adding a task (task == null) or editing one.
class DialogBox extends StatefulWidget {
  final Task? task;
  final void Function(Task) onSave;

  const DialogBox({super.key, this.task, required this.onSave});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  static const _priorities = ['Low', 'Medium', 'High'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _subjectController;
  late DateTime _deadline;
  late String _priority;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _subjectController = TextEditingController(text: task?.subject ?? '');
    final now = DateTime.now();
    _deadline = task?.deadline ?? DateTime(now.year, now.month, now.day);
    _priority = task?.priority ?? 'Medium';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  void _submit() {
    // Validation: stops here if a required field is empty.
    if (!_formKey.currentState!.validate()) return;

    final task = Task(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      subject: _subjectController.text.trim(),
      deadline: _deadline,
      priority: _priority,
      isDone: widget.task?.isDone ?? false,
    );
    widget.onSave(task);
    Navigator.of(context).pop();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green,
      title: Text(_isEditing ? 'Edit Task' : 'New Task'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _required(value, 'Title'),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _required(value, 'Subject'),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Deadline: ${DateFormat('MMM d, y').format(_deadline)}',
                    ),
                  ),
                  MyButtons(text: 'Change', onPressed: _pickDate),
                ],
              ),
              SizedBox(height: 10),
              Text('Priority'),
              SizedBox(height: 15),
              Wrap(
                spacing: 8,
                children: _priorities.map((p) {
                final isSelected = _priority == p;

              Color chipColor;
              switch (p) {
                case 'Low':
                chipColor = Colors.blue;
                break;
              case 'Medium':
                chipColor = Colors.orange;
                break;
              case 'High':
                chipColor = Colors.red;
                break;
              default:
                chipColor = Colors.grey.shade300;
            }

              return ChoiceChip(
                label: Text(
                  p,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                
                selected: isSelected,
                selectedColor: chipColor,
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? Colors.black : Colors.transparent,
                  ),
                ),
                onSelected: (_) => setState(() => _priority = p),
              );
            }).toList(),
          )
            ],
          ),
        ),
      ),
      actions: [
        MyButtons(text: 'Save', onPressed: _submit),
        MyButtons(text: 'Cancel', onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }
}
