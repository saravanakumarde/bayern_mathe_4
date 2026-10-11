import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';

class ProgressService extends ChangeNotifier {
  int totalAnswered = 0;
  int totalCorrect = 0;
  final Map<String, int> categoryCorrect = {};
  final Map<String, int> categoryTotal = {};

  double get accuracy => totalAnswered == 0 ? 0 : totalCorrect / totalAnswered;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    totalAnswered = prefs.getInt('totalAnswered') ?? 0;
    totalCorrect = prefs.getInt('totalCorrect') ?? 0;
    for (final cat in ExerciseCategory.values) {
      final key = cat.name;
      categoryCorrect[key] = prefs.getInt('correct_$key') ?? 0;
      categoryTotal[key] = prefs.getInt('total_$key') ?? 0;
    }
    notifyListeners();
  }

  Future<void> recordAnswer(ExerciseCategory category, bool correct) async {
    totalAnswered++;
    if (correct) totalCorrect++;
    final key = category.name;
    categoryTotal[key] = (categoryTotal[key] ?? 0) + 1;
    if (correct) categoryCorrect[key] = (categoryCorrect[key] ?? 0) + 1;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalAnswered', totalAnswered);
    await prefs.setInt('totalCorrect', totalCorrect);
    await prefs.setInt('correct_$key', categoryCorrect[key]!);
    await prefs.setInt('total_$key', categoryTotal[key]!);
    notifyListeners();
  }

  Future<void> reset() async {
    totalAnswered = 0;
    totalCorrect = 0;
    categoryCorrect.clear();
    categoryTotal.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
