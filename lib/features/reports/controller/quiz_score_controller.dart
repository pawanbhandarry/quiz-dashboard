import 'package:get/get.dart';

import '../../../data/repositories/reports/quiz_score_repository.dart';
import '../models/quiz_score_model.dart';
import '../../../data/abstract/base_data_table_controller.dart';

class ScoreController extends TBaseController<QuizScoreModel> {
  static ScoreController get instance => Get.find();

  final RxList<QuizScoreModel> scores = <QuizScoreModel>[].obs;
  final _scoreRepository = Get.put(QuizScoreRepository());

  // Filtering options
  final RxString selectedQuizFilter = ''.obs;
  final RxString selectedCategoryFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadScores();
  }

  // Load scores based on current filters
  Future<void> loadScores() async {
    try {
      final fetchedScores = await fetchItems();
      allItems.assignAll(fetchedScores);
      print('Fetched Scores Count: ${fetchedScores.length}');
    } catch (e) {
      print('Failed to load scores: $e');
    }
  }

  // Fetch scores with optional filtering
  Future<List<QuizScoreModel>> fetchFilteredScores() async {
    try {
      if (selectedQuizFilter.isNotEmpty) {
        return await _scoreRepository.getQuizScores(selectedQuizFilter.value);
      }

      // If no specific quiz, get leaderboard scores
      return await _scoreRepository.getLeaderboardScores();
    } catch (e) {
      print('Error fetching filtered scores: $e');
      return [];
    }
  }

  // Save a new quiz score
  Future<QuizScoreModel?> saveScore(QuizScoreModel score) async {
    try {
      final savedScore = await _scoreRepository.saveQuizScore(score);
      allItems.add(savedScore);
      return savedScore;
    } catch (e) {
      print('Failed to save score: $e');
      return null;
    }
  }

  // Set quiz filter
  void setQuizFilter(String quizId) {
    selectedQuizFilter.value = quizId;
    selectedCategoryFilter.value = ''; // Clear category filter
    loadScores();
  }

  // Set category filter
  void setCategoryFilter(String categoryId) {
    selectedCategoryFilter.value = categoryId;
    selectedQuizFilter.value = ''; // Clear quiz filter
    loadScores();
  }

  @override
  Future<List<QuizScoreModel>> fetchItems() async {
    return await fetchFilteredScores();
  }

  @override
  Future<void> deleteItem(QuizScoreModel item) async {
    // Implement delete logic if needed
    // Note: Typically, scores are not deleted but archived
  }

  @override
  bool containsSearchQuery(QuizScoreModel item, String query) {
    return item.userId.toLowerCase().contains(query.toLowerCase()) ||
        item.quizId.toLowerCase().contains(query.toLowerCase());
  }

  // Sorting methods
  void sortByScore(int sortColumnIndex, bool ascending) {
    sortByProperty(
        sortColumnIndex, ascending, (QuizScoreModel score) => score.totalScore);
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(
        sortColumnIndex, ascending, (QuizScoreModel score) => score.createdAt);
  }
}
