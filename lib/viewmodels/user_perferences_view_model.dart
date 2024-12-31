import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/user_preferences.dart';

final userPreferencesProvider = StateNotifierProvider<UserPreferencesViewModel, UserPreferences>((ref) {
  return UserPreferencesViewModel();
});

class UserPreferencesViewModel extends StateNotifier<UserPreferences> {
  UserPreferencesViewModel() : super(UserPreferences()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final box = await Hive.openBox<UserPreferences>('preferences');
    final preferences = box.get('user_preferences') ?? UserPreferences();
    state = preferences;
  }

  Future<void> updatePreferences(UserPreferences preferences) async {
    final box = await Hive.openBox<UserPreferences>('preferences');
    box.put('user_preferences', preferences);
    state = preferences;
  }

  void toggleTheme() {
    final updatedPreferences = UserPreferences(
      isDarkMode: !state.isDarkMode,
      defaultSortOrder: state.defaultSortOrder,
    );
    updatePreferences(updatedPreferences);
  }

  void updateSortOrder(String sortOrder) {
    final updatedPreferences = UserPreferences(
      isDarkMode: state.isDarkMode,
      defaultSortOrder: sortOrder,
    );
    updatePreferences(updatedPreferences);
  }
}
