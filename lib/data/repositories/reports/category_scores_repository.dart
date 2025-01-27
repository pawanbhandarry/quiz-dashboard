import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/reports/models/category_score_model.dart';

class CategoryScoreRepository extends GetxController {
  static CategoryScoreRepository get instance => Get.find();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch aggregated scores for a specific category
  Future<CategoryScoreModel> getCategoryScores(String categoryId) async {
    try {
      // Fetch all quizzes in the category
      final quizResponse = await _supabase
          .from('quizes')
          .select('id, title')
          .eq('category_id', categoryId);

      // Prepare to aggregate scores
      List<dynamic> quizScores = [];
      int totalMaxScore = 0;
      int totalActualScore = 0;

      // Fetch scores for each quiz in the category
      for (var quiz in quizResponse) {
        final scoresResponse = await _supabase
            .from('quiz_scores')
            .select()
            .eq('quiz_id', quiz['id']);

        // Aggregate scores for this quiz
        int quizMaxScore = scoresResponse.fold(
            0,
            (max, score) =>
                max +
                (int.tryParse(score['maximum_score']?.toString() ?? '0') ?? 0));

        int quizActualScore = scoresResponse.fold(
            0,
            (total, score) =>
                total +
                (int.tryParse(score['total_score']?.toString() ?? '0') ?? 0));

        quizScores.add({
          'quiz_id': quiz['id'],
          'quiz_title': quiz['title'],
          'max_score': quizMaxScore,
          'actual_score': quizActualScore,
          'participants_count': scoresResponse.length,
        });

        totalMaxScore += quizMaxScore;
        totalActualScore += quizActualScore;
      }

      return CategoryScoreModel(
        categoryId: categoryId,
        totalMaxScore: totalMaxScore,
        totalActualScore: totalActualScore,
        quizScores: quizScores,
        participantsCount: quizScores.fold(0,
            (total, quiz) => total + (quiz['participants_count'] ?? 0) as int),
      );
    } catch (e) {
      print('Error fetching category scores: $e');
      rethrow;
    }
  }
}
