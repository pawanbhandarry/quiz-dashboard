import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/reports/models/quiz_score_model.dart';
import '../../../utils/exceptions/supabase_exceptions.dart';

class QuizScoreRepository extends GetxController {
  static QuizScoreRepository get instance => Get.find();

  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tableName = 'quiz_scores';

  // Helper method to check authentication
  void _checkAuth() {
    final session = _supabase.auth.currentSession;
    if (session == null) {
      throw 'User not authenticated';
    }
  }

  // Save a new quiz score
  Future<QuizScoreModel> saveQuizScore(QuizScoreModel score) async {
    try {
      _checkAuth();

      final response = await _supabase
          .from(_tableName)
          .insert({
            'user_id': score.userId,
            'quiz_id': score.quizId,
            'total_score': score.totalScore,
            'maximum_score': score.maximumScore,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return QuizScoreModel.fromJson(response);
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Get scores for a specific user
  Future<List<QuizScoreModel>> getUserScores(String userId) async {
    try {
      _checkAuth();

      final response = await _supabase
          .from(_tableName)
          .select('*, quizzes(title, category_id)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response.map((json) => QuizScoreModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Get scores for a specific quiz
  Future<List<QuizScoreModel>> getQuizScores(String quizId) async {
    try {
      _checkAuth();

      final response = await _supabase
          .from(_tableName)
          .select('*, users(name, email)')
          .eq('quiz_id', quizId)
          .order('total_score', ascending: false);

      return response.map((json) => QuizScoreModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Get leaderboard scores across all quizzes
  Future<List<QuizScoreModel>> getLeaderboardScores() async {
    try {
      _checkAuth();

      final response = await _supabase
          .from(_tableName)
          .select('*, users(name, email), quizzes(title)')
          .order('total_score', ascending: false)
          .limit(100);

      return response.map((json) => QuizScoreModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }
}
