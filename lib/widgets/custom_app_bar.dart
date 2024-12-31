import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/user_perferences_view_model.dart';
import '../models/user_preferences.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool isCentered;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.isCentered = true,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreferences = ref.watch(userPreferencesProvider);

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: isCentered,
      actions: [
        // Sort button
        PopupMenuButton<String>(
          icon: const Icon(Icons.sort, color: Colors.grey),
          tooltip: 'Sort tasks',
          onSelected: (String value) {
            ref.read(userPreferencesProvider.notifier).updateSortOrder(value);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: UserPreferences.SORT_BY_NAME,
              child: ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Sort by Name'),
                selected: userPreferences.defaultSortOrder == UserPreferences.SORT_BY_NAME,
              ),
            ),
            PopupMenuItem<String>(
              value: UserPreferences.SORT_BY_PRIORITY,
              child: ListTile(
                leading: const Icon(Icons.priority_high),
                title: const Text('Sort by Priority'),
                selected: userPreferences.defaultSortOrder == UserPreferences.SORT_BY_PRIORITY,
              ),
            ),
            PopupMenuItem<String>(
              value: UserPreferences.SORT_BY_DATE,
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Sort by Date'),
                selected: userPreferences.defaultSortOrder == UserPreferences.SORT_BY_DATE,
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: UserPreferences.SORT_BY_PENDING_FIRST,
              child: ListTile(
                leading: const Icon(Icons.pending_actions),
                title: const Text('Pending First'),
                selected: userPreferences.defaultSortOrder == UserPreferences.SORT_BY_PENDING_FIRST,
              ),
            ),
            PopupMenuItem<String>(
              value: UserPreferences.SORT_BY_COMPLETED_FIRST,
              child: ListTile(
                leading: const Icon(Icons.task_alt),
                title: const Text('Completed First'),
                selected: userPreferences.defaultSortOrder == UserPreferences.SORT_BY_COMPLETED_FIRST,
              ),
            ),
          ],
        ),
        // Theme toggle button
        IconButton(
          icon: Icon(
            userPreferences.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: Colors.grey,
          ),
          onPressed: () {
            ref.read(userPreferencesProvider.notifier).toggleTheme();
          },
          tooltip: userPreferences.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
        ),
        if (actions != null) ...actions!,
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              userPreferences.isDarkMode ? Colors.grey[800]! : Color(0xFFfaedcd),
              userPreferences.isDarkMode ? Colors.grey[900]! : Color(0xFFfaedcd),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}