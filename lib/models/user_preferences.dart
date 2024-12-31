import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 0)
class UserPreferences extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  String defaultSortOrder;

  static const String SORT_BY_NAME = 'name';
  static const String SORT_BY_PRIORITY = 'priority';
  static const String SORT_BY_DATE = 'date';
  static const String SORT_BY_PENDING_FIRST = 'pending_first';
  static const String SORT_BY_COMPLETED_FIRST = 'completed_first';

  UserPreferences({
    this.isDarkMode = false,
    this.defaultSortOrder = SORT_BY_DATE
  });
}