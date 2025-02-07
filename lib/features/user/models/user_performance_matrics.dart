import '../../reports/models/quiz_score_model.dart';

class PerformanceMetrics {
  final int totalQuizzes;
  final double overallScore;
  final double accuracy;
  final double averageTimeTaken;
  final String topPerformingCategory;
  final List<String> improvementNeededCategories;
  final QuizScoreModel topPerformingQuiz;
  final double incorrectRate; // New field
  final double skippedRate; // New field
  final int totalIncorrectAnswers; // New field
  final int totalSkippedQuestions; // New field

  PerformanceMetrics({
    required this.totalQuizzes,
    required this.overallScore,
    required this.accuracy,
    required this.averageTimeTaken,
    required this.topPerformingCategory,
    required this.improvementNeededCategories,
    required this.topPerformingQuiz,
    required this.incorrectRate,
    required this.skippedRate,
    required this.totalIncorrectAnswers,
    required this.totalSkippedQuestions,
  });

  factory PerformanceMetrics.empty() {
    return PerformanceMetrics(
      totalQuizzes: 0,
      overallScore: 0,
      accuracy: 0,
      averageTimeTaken: 0,
      topPerformingCategory: 'N/A',
      improvementNeededCategories: [],
      topPerformingQuiz: QuizScoreModel(
        quizTitle: 'N/A',
        categoryName: 'N/A',
        score: 0,
        totalScore: 1,
        incorrectAnswers: 0,
        timeTaken: 0,
        id: '',
        userId: '',
        quizId: '',
        categoryId: '',
      ),
      incorrectRate: 0,
      skippedRate: 0,
      totalIncorrectAnswers: 0,
      totalSkippedQuestions: 0,
    );
  }
}
