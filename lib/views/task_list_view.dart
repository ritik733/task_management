import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/task_view_model.dart';
import '../viewmodels/user_perferences_view_model.dart';
import '../models/user_preferences.dart';
import '../widgets/task_card.dart';
import 'add_edit_task_view.dart';

class TaskListView extends ConsumerWidget {
  const TaskListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final userPreferences = ref.watch(userPreferencesProvider);

    // Sort tasks based on user preference
    final sortedTasks = [...tasks]; // Create a copy to sort
    switch (userPreferences.defaultSortOrder) {
      case UserPreferences.SORT_BY_NAME:
        sortedTasks.sort((a, b) => a.title.compareTo(b.title));
        break;
      case UserPreferences.SORT_BY_PRIORITY:
        sortedTasks.sort((a, b) {
          // Sort by priority (high to low) and then by date
          final priorityComparison = b.priority.index.compareTo(a.priority.index);
          if (priorityComparison != 0) {
            return priorityComparison;
          }
          return a.date.compareTo(b.date);
        });
        break;
      case UserPreferences.SORT_BY_PENDING_FIRST:
        sortedTasks.sort((a, b) {
          // Sort by completion status (pending first) and then by date
          if (!a.isCompleted && b.isCompleted) return -1;
          if (a.isCompleted && !b.isCompleted) return 1;
          return a.date.compareTo(b.date);
        });
        break;
      case UserPreferences.SORT_BY_COMPLETED_FIRST:
        sortedTasks.sort((a, b) {
          // Sort by completion status (completed first) and then by date
          if (a.isCompleted && !b.isCompleted) return -1;
          if (!a.isCompleted && b.isCompleted) return 1;
          return a.date.compareTo(b.date);
        });
        break;
      case UserPreferences.SORT_BY_DATE:
      default:
        sortedTasks.sort((a, b) => a.date.compareTo(b.date));
        break;
    }

    return ListView.builder(
      itemCount: sortedTasks.length,
      itemBuilder: (context, index) {
        return TaskCard(
          task: sortedTasks[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditTaskView(task: sortedTasks[index]),
              ),
            );
          },
          onDelete: () {
            ref.read(taskProvider.notifier).deleteTask(sortedTasks[index].id);
          },
          onStatusChanged: (bool? value) {
            if (value != null) {
              ref.read(taskProvider.notifier).toggleTaskStatus(sortedTasks[index].id);
            }
          },
        );
      },
    );
  }
}