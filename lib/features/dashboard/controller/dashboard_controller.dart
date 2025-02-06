import 'package:get/get.dart';

import '../../../data/repositories/quizes/quiz_repository.dart';
import '../../../data/repositories/categories/category_repository.dart';
import '../../../data/repositories/reports/quiz_score_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../quizes/models/quizes_models.dart';
import '../../reports/controller/quiz_score_controller.dart';
import '../../reports/models/quiz_score_model.dart';
import '../../user/models/user_models.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();

  final _userRepository = Get.put(UserRepository());
  final _quizRepository = Get.put(QuizRepository());
  final _categoryRepository = Get.put(CategoryRepository());
  final _quizScoreRepository = Get.put(QuizScoreRepository());

  // Observables for statistics
  var totalCategories = 0.obs;
  var totalQuizzes = 0.obs;
  var totalUsers = 0.obs;
  var totalActiveUsers = 0.obs;
  var activationCodesUsed = 0.obs;

  // Data for charts
  var weeklyQuizAttempts =
      <String, int>{}.obs; // Holds quiz attempt count per day

  var topPerformingQuizzes = <Map<String, dynamic>>[].obs;
  var recentQuizAttempts = <QuizScoreModel>[].obs;
  var performanceGraphData = {}.obs; // Data for bar chart
  final RxList<Map<String, dynamic>> performanceData =
      <Map<String, dynamic>>[].obs;
  var topUsers = <UserModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    Get.put(QuizScoreController());
    fetchDashboardStatistics();
  }

  /// Fetch statistics for the dashboard
  Future<void> fetchDashboardStatistics() async {
    try {
      // Fetch total counts
      totalCategories.value =
          (await _categoryRepository.getAllCategories()).length;
      totalQuizzes.value = (await _quizRepository.getAllQuizzes()).length;
      totalUsers.value = (await _userRepository.getAllUsers()).length;
      totalActiveUsers.value = (await _userRepository.getAllUsers()).length;
      fetchTopUsers();

      fetchTopPerformingQuizzes();
      fetchRecentQuizAttempts();
      fetchWeeklyQuizAttempts();
    } catch (e) {
      print('Error fetching dashboard statistics: $e');
    }
  }

  Future<void> fetchTopUsers() async {
    final users = await _userRepository.getTopUsers(limit: 10);
    topUsers.assignAll(users);
  }

  Future<void> fetchWeeklyQuizAttempts() async {
    final attempts = await _quizScoreRepository.getWeeklyQuizAttempts();
    weeklyQuizAttempts.assignAll(attempts);
  }

  /// Fetch activation codes used count
  // Future<int> _getActivationCodesUsed() async {
  //   // Assuming a function exists in the repository
  //   return await _quizRepository.getActivationCodesUsedCount();
  // }

  /// Fetch top-performing quizzes
  // Future<List<QuizModel>> _fetchTopPerformingQuizzes() async {
  //   final quizzes = await _quizRepository.getAllQuizzes();
  //   quizzes.sort((a, b) =>
  //       b.participants.compareTo(a.participants)); // Sort by participants
  //   return quizzes.take(5).toList(); // Return top 5
  // }

  /// Fetch recent quiz attempts (last 10 attempts)
  Future<List<QuizScoreModel>> _fetchRecentQuizAttempts() async {
    final attempts = await _quizScoreRepository.getLeaderboardScores();
    return attempts.take(10).toList();
  }

  /// Prepare data for performance graph (bar chart)
  Future<void> _fetchPerformanceData() async {
    try {
      final scores = await _quizScoreRepository.getLeaderboardScores();

      // Convert scores into a mapped list
      performanceData.assignAll(scores
          .map((score) => {
                "quizTitle": score.quizTitle ?? "Unknown",
                "score": score.score,
              })
          .toList());
    } catch (e) {
      print("Error fetching performance data: $e");
    }
  }

  /// Fetches the top-performing quizzes based on participation count
  Future<void> fetchTopPerformingQuizzes() async {
    try {
      final scores = await _quizScoreRepository.getLeaderboardScores();

      // Count quiz participation
      Map<String, int> quizParticipation = {};
      Map<String, String> quizTitles = {};

      for (var score in scores) {
        quizParticipation[score.quizId] =
            (quizParticipation[score.quizId] ?? 0) + 1;
        quizTitles[score.quizId] = score.quizTitle ?? "Unknown Quiz";
      }

      // Sort by most participation
      var sortedQuizzes = quizParticipation.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Convert to list of maps for UI display
      topPerformingQuizzes.assignAll(sortedQuizzes
          .take(5) // Limit to top 5 quizzes
          .map(
              (entry) => {"title": quizTitles[entry.key], "count": entry.value})
          .toList());
    } catch (e) {
      print("Error fetching top-performing quizzes: $e");
    }
  }

  /// Fetches recent quiz attempts (latest quiz activity logs)
  Future<void> fetchRecentQuizAttempts() async {
    try {
      final scores = await _quizScoreRepository.getLeaderboardScores();

      // Sort by latest attempt
      scores.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      // Limit to the last 5 attempts
      recentQuizAttempts.assignAll(scores.take(5));
    } catch (e) {
      print("Error fetching recent quiz attempts: $e");
    }
  }

  /// Fetches performance graph data for user scores and trends (bar chart)
  Future<void> fetchPerformanceGraphData() async {
    try {
      final scores = await _quizScoreRepository.getLeaderboardScores();

      // Aggregate scores per quiz
      Map<String, double> quizScores = {};
      Map<String, int> quizCounts = {};

      for (var score in scores) {
        quizScores[score.quizId] =
            (quizScores[score.quizId] ?? 0) + score.score;
        quizCounts[score.quizId] = (quizCounts[score.quizId] ?? 0) + 1;
      }

      // Calculate average scores
      Map<String, double> performanceData = {};
      quizScores.forEach((quizId, totalScore) {
        double avgScore = totalScore / quizCounts[quizId]!;
        performanceData[quizId] = avgScore;
      });

      performanceGraphData.assignAll(performanceData);
    } catch (e) {
      print("Error fetching performance graph data: $e");
    }
  }
}
