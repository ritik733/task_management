import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Function(bool?)? onStatusChanged;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onDelete,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: task.isCompleted,
                      onChanged: onStatusChanged,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Icon(
                    Icons.flag,
                    color: task.priority.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? Theme.of(context).disabledColor
                            : null,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    color: Colors.red,
                  ),
                ],
              ),
              if (task.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 48.0),
                  child: Text(
                    task.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: task.isCompleted
                          ? Theme.of(context).disabledColor
                          : null,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 48.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      _formatDate(task.date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Icon(
                      Icons.flag,
                      size: 16.0,
                      color: task.priority.color,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      task.priority.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: task.priority.color,
                      ),
                    ),
                    if (task.isCompleted) ...[
                      const SizedBox(width: 16.0),
                      Icon(
                        Icons.check_circle,
                        size: 16.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Completed',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}