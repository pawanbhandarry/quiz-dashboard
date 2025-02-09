import 'package:dashboard/features/user/models/user_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../reports/models/quiz_score_model.dart';
import '../../setting/models/admin_model.dart';
import '../models/user_category_stats.dart';
import '../models/user_performance_matrics.dart';

class UserDetailController extends GetxController {
  static UserDetailController get instance => Get.find();

  RxBool ordersLoading = true.obs;
  RxBool addressesLoading = true.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<bool> selectedRows = <bool>[].obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final searchTextController = TextEditingController();

  /// -- Search Query Filter
  PerformanceMetrics calculatePerformanceMetrics(List<QuizScoreModel> scores) {
    if (scores.isEmpty) return PerformanceMetrics.empty();

    final totalQuizzes = scores.length;
    final totalCorrectAnswers =
        scores.fold(0, (sum, score) => sum + score.score);
    final totalQuestions =
        scores.fold(0, (sum, score) => sum + score.totalScore);
    final totalIncorrectAnswers =
        scores.fold(0, (sum, score) => sum + score.incorrectAnswers);

    // Calculate skipped questions
    final totalSkippedQuestions = scores.fold(
        0,
        (sum, score) =>
            sum + (score.totalScore - (score.score + score.incorrectAnswers)));

    final overallScore = (totalCorrectAnswers / totalQuestions) * 100;
    final accuracy =
        (totalCorrectAnswers / (totalCorrectAnswers + totalIncorrectAnswers)) *
            100;
    final incorrectRate = (totalIncorrectAnswers / totalQuestions) * 100;
    final skippedRate = (totalSkippedQuestions / totalQuestions) * 100;

    final averageTimeTaken =
        scores.map((s) => s.timeTaken).reduce((a, b) => a + b) / totalQuizzes;

    return PerformanceMetrics(
      totalQuizzes: totalQuizzes,
      overallScore: overallScore,
      accuracy: accuracy,
      averageTimeTaken: averageTimeTaken,
      topPerformingCategory: findTopPerformingCategory(scores),
      improvementNeededCategories: _findImprovementNeededCategories(scores),
      topPerformingQuiz: _findTopPerformingQuiz(scores),
      incorrectRate: incorrectRate,
      skippedRate: skippedRate,
      totalIncorrectAnswers: totalIncorrectAnswers,
      totalSkippedQuestions: totalSkippedQuestions,
    );
  }

  QuizScoreModel _findTopPerformingQuiz(List<QuizScoreModel> scores) {
    return scores.reduce(
        (a, b) => (a.score / a.totalScore) > (b.score / b.totalScore) ? a : b);
  }

  String findTopPerformingCategory(List<QuizScoreModel> scores) {
    final categoryPerformance = <String, double>{};

    for (var score in scores) {
      final categoryName = score.categoryName ?? 'Uncategorized';
      final performance = (score.score / score.totalScore) * 100;

      categoryPerformance[categoryName] =
          (categoryPerformance[categoryName] ?? 0) + performance;
    }

    return categoryPerformance.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  List<String> _findImprovementNeededCategories(List<QuizScoreModel> scores) {
    return scores
        .where((score) => (score.score / score.totalScore) * 100 < 50)
        .map((score) => score.categoryName ?? 'Uncategorized')
        .toList();
  }

  Map<String, CategoryStats> calculateDetailedCategoryStats(
      List<QuizScoreModel> scores) {
    final categoryMap = <String, CategoryStats>{};

    // Group scores by category
    final groupedScores = <String, List<QuizScoreModel>>{};
    for (final score in scores) {
      final category = score.categoryName ?? 'General';
      groupedScores.putIfAbsent(category, () => []).add(score);
    }

    // Calculate detailed stats for each category
    groupedScores.forEach((category, categoryScores) {
      final performances =
          categoryScores.map((s) => (s.score / s.totalScore) * 100).toList();

      final averageScore =
          performances.reduce((a, b) => a + b) / performances.length;
      final highestScore = performances.reduce((a, b) => a > b ? a : b);
      final lowestScore = performances.reduce((a, b) => a < b ? a : b);
      final totalAttempts = categoryScores.length;
      final passCount = categoryScores
          .where((s) => (s.score / s.totalScore) * 100 >= 70)
          .length;
      final averageTimeTaken =
          categoryScores.map((s) => s.timeTaken).reduce((a, b) => a + b) /
              categoryScores.length;

      categoryMap[category] = CategoryStats(
        averageScore: averageScore,
        highestScore: highestScore,
        lowestScore: lowestScore,
        totalAttempts: totalAttempts,
        passCount: passCount,
        averageTimeTaken: averageTimeTaken,
      );
    });

    // Sort by average score in descending order
    final sortedCategoryList = categoryMap.entries.toList()
      ..sort((a, b) => b.value.averageScore.compareTo(a.value.averageScore));

    // Return the sorted map
    return Map.fromEntries(sortedCategoryList);
  }

  Map<String, CategoryStats> getCategoryStats(List<QuizScoreModel> scores) {
    return calculateDetailedCategoryStats(scores);
  }
}
