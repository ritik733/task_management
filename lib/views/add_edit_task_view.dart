import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../viewmodels/task_view_model.dart';

class AddEditTaskView extends ConsumerStatefulWidget {
  final Task? task;
  const AddEditTaskView({Key? key, this.task}) : super(key: key);

  @override
  AddEditTaskViewState createState() => AddEditTaskViewState();
}

class AddEditTaskViewState extends ConsumerState<AddEditTaskView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime _selectedDate = DateTime.now();
  TaskPriority _selectedPriority = TaskPriority.medium;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    if (widget.task != null) {
      _selectedDate = widget.task!.date;
      _selectedPriority = widget.task!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final taskViewModel = ref.read(taskProvider.notifier);
      final task = Task(
        id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        isCompleted: widget.task?.isCompleted ?? false,
        priority: _selectedPriority,
      );

      if (widget.task == null) {
        await taskViewModel.addTask(task);
      } else {
        await taskViewModel.updateTask(task);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving task: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFfaedcd), Color(0xFFfaedcd)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          _isLoading
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: Colors.grey),
            ),
          )
              : IconButton(
            icon: const Icon(Icons.save, color: Colors.grey),
            onPressed: _saveTask,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Priority Selection
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.flag,
                    color: _selectedPriority.color,
                  ),
                  title: const Text('Priority'),
                  subtitle: Text(_selectedPriority.name),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Select Priority'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: TaskPriority.values.map((priority) {
                            return ListTile(
                              leading: Icon(
                                Icons.flag,
                                color: priority.color,
                              ),
                              title: Text(priority.name),
                              selected: priority == _selectedPriority,
                              onTap: () {
                                setState(() => _selectedPriority = priority);
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Due Date'),
                  subtitle: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      setState(() => _selectedDate = pickedDate);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: !_isLoading
          ? FloatingActionButton.extended(
        onPressed: _saveTask,
        icon: const Icon(Icons.save),
        label: const Text('Save Task'),
        backgroundColor: Color(0xFFfaedcd),
      )
          : null,
    );
  }
}