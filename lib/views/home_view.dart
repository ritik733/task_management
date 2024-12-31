import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'task_list_view.dart';
import 'add_edit_task_view.dart';
import '../viewmodels/task_view_model.dart';
import '../viewmodels/user_perferences_view_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/responsive_layout.dart';

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskViewModel = ref.watch(taskProvider.notifier);
    final userPreferencesViewModel = ref.watch(userPreferencesProvider.notifier);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Task Management",
      ),
      body: ResponsiveLayout(
        mobileView: TaskListView(),
        tabletView: Row(
          children: [
            Expanded(child: TaskListView()),
            const Expanded(
              child: Placeholder(), // Placeholder for task details view
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFfaedcd),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditTaskView(),
            ),
          );
        },
        child: const Icon(Icons.add,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}