import 'package:dashboard/data/repositories/quizes/quiz_repository.dart';

import 'package:dashboard/data/repositories/categories/category_repository.dart';

import 'package:get/get.dart';

import '../../../data/abstract/base_data_table_controller.dart';
import '../../../data/repositories/reports/quiz_score_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../category/models/category_model.dart';
import '../../quizes/models/quizes_models.dart';
import '../../user/models/user_models.dart';
import '../models/quiz_score_model.dart';

class QuizScoreController extends TBaseController<QuizScoreModel> {
  static QuizScoreController get instance => Get.find();

  final RxList<QuizScoreModel> quizScores = <QuizScoreModel>[].obs;
  final RxList<UserModel> users = <UserModel>[].obs;
  final RxList<QuizModel> quizzes = <QuizModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  final _quizScoreRepository = Get.put(QuizScoreRepository());
  final _quizRepository = Get.put(QuizRepository());
  final _userRepository = Get.put(UserRepository());
  final _categoryRepository = Get.put(CategoryRepository());

  final RxString selectedUser = ''.obs;
  final RxString selectedQuiz = ''.obs;
  final RxString selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuizScores();
    loadUsers();
    loadQuizzes();
    loadCategories();
  }

  Future<void> loadQuizScores() async {
    try {
      if (selectedUser.isNotEmpty && selectedCategory.isNotEmpty) {
        // Filter by User + Category
        final quizScores =
            await _quizScoreRepository.getQuizScoresByUserAndCategory(
                selectedUser.value, selectedCategory.value);
        updateQuizScoresList(quizScores);
      } else if (selectedUser.isNotEmpty && selectedQuiz.isNotEmpty) {
        // Filter by User + Quiz
        final quizScores = await _quizScoreRepository
            .getQuizScoresByUserAndQuiz(selectedUser.value, selectedQuiz.value);
        updateQuizScoresList(quizScores);
      } else if (selectedUser.isNotEmpty) {
        // Filter by User only
        final quizScores =
            await _quizScoreRepository.getQuizScoresByUser(selectedUser.value);
        updateQuizScoresList(quizScores);
      } else if (selectedQuiz.isNotEmpty) {
        // Filter by Quiz only
        final quizScores =
            await _quizScoreRepository.getQuizScoresByQuiz(selectedQuiz.value);
        updateQuizScoresList(quizScores);
      } else if (selectedCategory.isNotEmpty) {
        // Filter by Category only
        final quizScores = await _quizScoreRepository
            .getQuizScoresByCategory(selectedCategory.value);
        updateQuizScoresList(quizScores);
      } else {
        // Default: Get all leaderboard scores
        final quizScores = await _quizScoreRepository.getLeaderboardScores();
        updateQuizScoresList(quizScores);
      }

      print('Loaded ${allItems.length} quiz scores');
    } catch (e) {
      print('Failed to load quiz scores: $e');
    }
  }

  /// Helper function to update quiz scores list
  void updateQuizScoresList(List<QuizScoreModel> quizScores) {
    allItems.clear();
    allItems.assignAll(quizScores);
    allItems.refresh(); // Ensure UI updates
    filteredItems.clear();
    filteredItems.assignAll(quizScores);
    filteredItems.refresh();
  }

  Future<void> loadUsers() async {
    try {
      users.assignAll(await _userRepository.getAllUsers());
    } catch (e) {
      print('Failed to load users: $e');
    }
  }

  Future<void> loadQuizzes() async {
    try {
      quizzes.assignAll(await _quizRepository.getAllQuizzes());
    } catch (e) {
      print('Failed to load quizzes: $e');
    }
  }

  Future<void> loadCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllCategories());
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  void filterByUser(String userId) {
    selectedUser.value = userId;

    // If category is already selected, filter by user + category
    if (selectedCategory.isNotEmpty) {
      loadQuizScores();
      return;
    }

    // If quiz is already selected, filter by user + quiz
    if (selectedQuiz.isNotEmpty) {
      loadQuizScores();
      return;
    }

    // Otherwise, filter by user only
    loadQuizScores();
  }

  void filterByQuiz(String quizId) {
    selectedQuiz.value = quizId;
    selectedCategory.value = '';

    // If user is already selected, filter by user + quiz
    if (selectedUser.isNotEmpty) {
      loadQuizScores();
      return;
    }

    // Otherwise, filter by quiz only
    loadQuizScores();
  }

  void filterByCategory(String categoryId) {
    selectedCategory.value = categoryId;
    selectedQuiz.value = '';

    // If user is already selected, filter by user + category
    if (selectedUser.isNotEmpty) {
      loadQuizScores();
      return;
    }

    // Otherwise, filter by category only
    loadQuizScores();
  }

  void clearFilters() {
    selectedUser.value = '';
    selectedQuiz.value = '';
    selectedCategory.value = '';
    loadQuizScores();
  }

  @override
  Future<void> deleteItem(QuizScoreModel item) async {
    await _quizScoreRepository.deleteQuizScore(item.id);
    loadQuizScores();
  }

  @override
  Future<List<QuizScoreModel>> fetchItems() async {
    await loadQuizScores();
    return allItems;
  }

  @override
  bool containsSearchQuery(QuizScoreModel item, String query) {
    return item.userName!.toLowerCase().contains(query.toLowerCase()) ||
        item.quizTitle!.toLowerCase().contains(query.toLowerCase());
  }

  bool sortByScore(int sortColumnIndex, bool ascending) {
    sortByProperty(
        sortColumnIndex, ascending, (QuizScoreModel score) => score.score);
    return true;
  }

  bool sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(
        sortColumnIndex, ascending, (QuizScoreModel score) => score.createdAt);
    return true;
  }

  bool sortByuserName(int sortColumnIndex, bool ascending) {
    sortByProperty(
        sortColumnIndex, ascending, (QuizScoreModel score) => score.userName);
    return true;
  }
}
