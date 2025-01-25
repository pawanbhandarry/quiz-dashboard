import 'package:dashboard/features/category/models/category_model.dart';
import 'package:dashboard/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/quizes/quiz_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/loaders.dart';
import '../models/quizes_models.dart';

class CreateQuizController extends GetxController {
  static CreateQuizController get instance => Get.find();

  final selectedCategory = CategoryModel.empty().obs;
  final loading = false.obs;

  final title = TextEditingController();
  final description = TextEditingController();
  final timer = TextEditingController(); // Timer in minutes
  final formKey = GlobalKey<FormState>();

  late final QuizRepository quizRepository;

  @override
  void onInit() {
    super.onInit();

    // Register QuizRepository using Get.put
    quizRepository = Get.put(QuizRepository());
  }

  /// Method to reset fields
  void resetFields() {
    selectedCategory(CategoryModel.empty());
    loading(false);

    title.clear();
    description.clear();
    timer.clear();
  }

  /// Create a new Quiz
  Future<void> createQuiz() async {
    try {
      // Start Loading
      TFullScreenLoader.popUpCircular();

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'No Internet',
            message: 'Please check your internet connection and try again.');
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Check if a category is selected
      if (selectedCategory.value.id.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'Category Required',
            message: 'Please select a category before creating a quiz.');
        return;
      }

      // Map Data
      final newQuiz = QuizModel(
        id: '',
        categoryId: selectedCategory.value.id,
        title: title.text.trim(),
        description: description.text.trim(),
        categoryName: selectedCategory.value.name,
        timer: int.parse(timer.text.trim()), // Convert timer to integer
        shareableCode: generateShareableCode(), // Generate a unique code
        createdAt: DateTime.now(),
      );

      // Call Repository to Create Quiz
      newQuiz.id = await quizRepository.createQuiz(newQuiz);

      // Reset Form
      resetFields();

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Success Message & Redirect
      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'New Quiz has been created.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Generate a unique shareable code
  String generateShareableCode() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
