import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/question/models/question_models.dart';

class QuestionRepository extends GetxController {
  static QuestionRepository get instance => Get.find();
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tableName = 'questions';

  void _checkAuth() {
    final session = _supabase.auth.currentSession;
    if (session == null) {
      throw 'User not authenticated';
    }
  }

  Future<String> createQuestion(QuestionModel question) async {
    try {
      _checkAuth();

      final response = await _supabase
          .from(_tableName)
          .insert({
            'question': question.question,
            'option_a': question.options['A'],
            'option_b': question.options['B'],
            'option_c': question.options['C'],
            'option_d': question.options['D'],
            'correct_answer': question.correctAnswer,
            'explanation': question.explanation,
            'image_url': question.imageUrl,
            'quiz_id': question.quizId,
            'category_id': question.categoryId,
          })
          .select()
          .single();

      if (response == null) {
        throw 'Failed to create question: No response';
      }

      return response['id'].toString();
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<QuestionModel>> getAllQuestions() async {
    try {
      _checkAuth();

      final List<dynamic> response = await _supabase.from(_tableName).select('''
          id, question, option_a, option_b, option_c, option_d, correct_answer,
          explanation, image_url, quiz_id, category_id,
          quizes(title), categories(name)
        ''');

      return response.map((question) {
        return QuestionModel(
          id: question['id'],
          question: question['question'],
          options: {
            'A': question['option_a'],
            'B': question['option_b'],
            'C': question['option_c'],
            'D': question['option_d'],
          },
          correctAnswer: question['correct_answer'],
          explanation: question['explanation'],
          imageUrl: question['image_url'],
          quizId: question['quiz_id'],
          categoryId: question['category_id'],
          quizName: question['quizes']?['title'], // Fetch dynamically
          categoryName: question['categories']?['name'], // Fetch dynamically
        );
      }).toList();
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<QuestionModel>> getQuestionsByQuiz(String quizId) async {
    try {
      _checkAuth();

      final List<dynamic> response = await _supabase.from(_tableName).select('''
          id, question, option_a, option_b, option_c, option_d, correct_answer,
          explanation, image_url, quiz_id, category_id,
          quizes(title), categories(name)
        ''').eq('quiz_id', quizId);

      return response.map((question) {
        return QuestionModel(
          id: question['id'],
          question: question['question'],
          options: {
            'A': question['option_a'],
            'B': question['option_b'],
            'C': question['option_c'],
            'D': question['option_d'],
          },
          correctAnswer: question['correct_answer'],
          explanation: question['explanation'],
          imageUrl: question['image_url'],
          quizId: question['quiz_id'],
          categoryId: question['category_id'],
          quizName: question['quizes']?['title'],
          categoryName: question['categories']?['name'],
        );
      }).toList();
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateQuestion(QuestionModel question) async {
    try {
      _checkAuth();

      await _supabase
          .from(_tableName)
          .update(question.toMap())
          .eq('id', question.id);
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> deleteQuestion(String questionId) async {
    try {
      _checkAuth();

      await _supabase.from(_tableName).delete().eq('id', questionId);
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }
}
