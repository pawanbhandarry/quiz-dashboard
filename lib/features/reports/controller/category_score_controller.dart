import 'package:get/get.dart';

import '../../../data/repositories/reports/category_scores_repository.dart';
import '../models/category_score_model.dart';

class CategoryScoreController extends GetxController {
  static CategoryScoreController get instance => Get.find();

  final _categoryScoreRepository = Get.put(CategoryScoreRepository());

  // Observable for category scores
  final Rx<CategoryScoreModel?> categoryScores = Rx<CategoryScoreModel?>(null);

  // Loading state
  final RxBool isLoading = false.obs;

  // Error handling
  final RxString errorMessage = ''.obs;

  // Fetch scores for a specific category
  Future<void> fetchCategoryScores(String categoryId) async {
    try {
      // Set loading state
      isLoading.value = true;
      errorMessage.value = '';

      // Fetch category scores
      final scores =
          await _categoryScoreRepository.getCategoryScores(categoryId);

      // Update observable
      categoryScores.value = scores;
    } catch (e) {
      // Handle errors
      errorMessage.value = 'Failed to fetch category scores';
      print(e);
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  // Reset category scores
  void resetCategoryScores() {
    categoryScores.value = null;
    errorMessage.value = '';
  }
}
