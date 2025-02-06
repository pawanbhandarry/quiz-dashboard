import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/quizes/models/quizes_models.dart';
import '../../../utils/exceptions/supabase_exceptions.dart';

class QuizRepository extends GetxController {
  static QuizRepository get instance => Get.find();

  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tableName = 'quizes';

  // Helper method to check authentication
  void _checkAuth() {
    final session = _supabase.auth.currentSession;
    if (session == null) {
      throw 'User not authenticated';
    }
  }

  // Create a new quiz
  Future<String> createQuiz(QuizModel quiz) async {
    try {
      _checkAuth();

      final response = await _supabase
          .from(_tableName)
          .insert({
            'category_id': quiz.categoryId,
            'title': quiz.title,
            'description': quiz.description,
            'timer': quiz.timer,
            'shareable_code': quiz.shareableCode,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      if (response == null) {
        throw 'Failed to create quiz: No response';
      }

      // Fetch and increment noof_quizes
      await _supabase.rpc('increment_category_quizzes',
          params: {'category_id': quiz.categoryId});

      return response['id'].toString();
    } on PostgrestException catch (e) {
      throw 'Database error: ${e.message}';
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get all quizzes with category names
  Future<List<QuizModel>> getAllQuizzes() async {
    try {
      _checkAuth();

      final List<dynamic> response = await _supabase
          .from(_tableName)
          .select('*, categories(name)')
          .order('created_at', ascending: false);

      return response.map((quiz) => QuizModel.fromJson(quiz)).toList();
    } on PostgrestException catch (e) {
      throw 'Database error: ${e.message}';
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get quizzes by category
  Future<List<QuizModel>> getQuizzesByCategory(String categoryId) async {
    try {
      _checkAuth();

      final List<dynamic> response = await _supabase
          .from(_tableName)
          .select('*, categories(name)')
          .eq('category_id', categoryId);

      return response.map((quiz) => QuizModel.fromJson(quiz)).toList();
    } on PostgrestException catch (e) {
      throw 'Database error: ${e.message}';
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Update an existing quiz
  Future<void> updateQuiz(QuizModel quiz) async {
    try {
      _checkAuth();

      await _supabase.from(_tableName).update({
        'title': quiz.title,
        'category_id': quiz.categoryId,
        'description': quiz.description,
        'timer': quiz.timer,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', quiz.id);
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    try {
      _checkAuth();

      // Simply delete the quiz, no need to update category count manually
      await _supabase.from(_tableName).delete().eq('id', quizId);
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  Future<QuizModel> getQuizById(String id) async {
    try {
      final response =
          await _supabase.from('quizes').select().eq('id', id).single();

      return QuizModel.fromJson(response);
    } catch (e) {
      throw 'Error fetching quiz: $e';
    }
  }
}
