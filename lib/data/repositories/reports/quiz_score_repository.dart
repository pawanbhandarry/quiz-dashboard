import 'package:dashboard/features/reports/models/quiz_score_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/exceptions/supabase_exceptions.dart';
import '../../../utils/helpers/helper_functions.dart';

class QuizScoreRepository {
  static QuizScoreRepository get instance => Get.find();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get scores of a specific quiz
  Future<List<QuizScoreModel>> getQuizScoresByQuiz(String quizId) async {
    print('Fetching scores for quiz: $quizId');
    final response = await _supabase
        .from('quiz_scores')
        .select('*, users(name), quizes(title), categories(name)')
        .eq('quiz_id', quizId);
    print('response: $response');

    return response
        .map((quizScore) => QuizScoreModel.fromJson(quizScore))
        .toList();
  }

  /// Get scores by category
  Future<List<QuizScoreModel>> getQuizScoresByCategory(
      String categoryId) async {
    print('categoryId: $categoryId');
    final response = await _supabase
        .from('quiz_scores')
        .select('*, users(name), quizes(title), categories(name)')
        .eq('category_id', categoryId);

    return response
        .map((quizScore) => QuizScoreModel.fromJson(quizScore))
        .toList();
  }

  /// Get scores by user
  Future<List<QuizScoreModel>> getQuizScoresByUser(String userId) async {
    final response = await _supabase
        .from('quiz_scores')
        .select('*, users(name), quizes(title), categories(name)')
        .eq('user_id', userId);

    return response.map((e) => QuizScoreModel.fromJson(e)).toList();
  }

  /// Get scores by user and category
  Future<List<QuizScoreModel>> getQuizScoresByUserAndCategory(
      String userId, String categoryId) async {
    final response = await _supabase
        .from('quiz_scores')
        .select('*, users(name), quizes(title), categories(name)')
        .eq('user_id', userId)
        .eq('category_id', categoryId);

    return response
        .map((quizScore) => QuizScoreModel.fromJson(quizScore))
        .toList();
  }

  /// Get scores by user and quiz
  Future<List<QuizScoreModel>> getQuizScoresByUserAndQuiz(
      String userId, String quizId) async {
    final response = await _supabase
        .from('quiz_scores')
        .select('*, users(name), quizes(title), categories(name)')
        .eq('user_id', userId)
        .eq('quiz_id', quizId);

    return response
        .map((quizScore) => QuizScoreModel.fromJson(quizScore))
        .toList();
  }

  /// Get overall leaderboard scores (sorted by totalScore)
  Future<List<QuizScoreModel>> getLeaderboardScores() async {
    final response = await _supabase
        .from('quiz_scores')
        .select('*, users(name), quizes(title), categories(name)')
        .order('score', ascending: false);

    return response.map((e) => QuizScoreModel.fromJson(e)).toList();
  }

  //get weakly quiz attempts
  Future<Map<String, int>> getWeeklyQuizAttempts() async {
    try {
      final response = await _supabase
          .from('quiz_scores')
          .select('created_at'); // Fetch only dates

      /// Create a map to store attempts count for each weekday
      Map<String, int> weeklyAttempts = {
        'Mon': 0,
        'Tue': 0,
        'Wed': 0,
        'Thu': 0,
        'Fri': 0,
        'Sat': 0,
        'Sun': 0
      };

      for (var doc in response) {
        DateTime attemptDate = DateTime.parse(doc['created_at']);
        String dayOfWeek = THelperFunctions.getDayOfWeek(
            attemptDate); // Convert to 'Mon', 'Tue', etc.

        if (weeklyAttempts.containsKey(dayOfWeek)) {
          weeklyAttempts[dayOfWeek] = (weeklyAttempts[dayOfWeek] ?? 0) + 1;
        }
      }

      return weeklyAttempts;
    } on PostgrestException catch (e) {
      throw TSupabaseException(e.message).message;
    } catch (e) {
      if (kDebugMode) print('Error fetching quiz attempts: $e');
      throw 'Something Went Wrong: $e';
    }
  }

  /// Save a new quiz score
  Future<void> addQuizScore(QuizScoreModel score) async {
    await _supabase.from('quiz_scores').insert(score.toJson());
  }

  /// Update a quiz score
  Future<void> updateQuizScore(String scoreId, int newScore) async {
    await _supabase
        .from('quiz_scores')
        .update({'score': newScore}).eq('id', scoreId);
  }

  /// Delete a quiz score
  Future<void> deleteQuizScore(String scoreId) async {
    await _supabase.from('quiz_scores').delete().eq('id', scoreId);
  }
}
