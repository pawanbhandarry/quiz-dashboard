import 'package:dashboard/data/repositories/quizes/quiz_repository.dart';
import 'package:dashboard/features/category/models/category_model.dart';
import 'package:dashboard/features/quizes/models/quizes_models.dart';
import 'package:dashboard/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/loaders.dart';
import '../../category/controller/category_controller.dart';

class EditQuizController extends GetxController {
  static EditQuizController get instance => Get.find();

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

    final categoryController = Get.put(CategoryController());
    categoryController.loadCategories();

    // Initialize QuizRepository
    quizRepository = Get.put(QuizRepository());
  }

  /// Initialize the controller with existing quiz data
  void init(QuizModel quiz) {
    // Ensure categories are loaded before processing
    final categoryController = CategoryController.instance;
    if (categoryController.allItems.isEmpty) {
      categoryController.loadCategories().then((_) {
        _initializeCategory(quiz);
      });
    } else {
      _initializeCategory(quiz);
    }
  }

  void _initializeCategory(QuizModel quiz) {
    title.text = quiz.title;
    description.text = quiz.description;
    timer.text = quiz.timer.toString();

    // Guaranteed to have categories now
    final matchingCategory = CategoryController.instance.allItems.firstWhere(
      (item) => item.id == quiz.categoryId,
      orElse: () => CategoryModel.empty(),
    );

    selectedCategory.value = matchingCategory;
    print('Matching Category: ${matchingCategory.name}');
  }

  /// Reset all fields
  void resetFields() {
    // selectedCategory(CategoryModel.empty());
    // loading(false);
    // title.clear();
    // description.clear();
    // timer.clear();
  }

  /// Update an existing quiz
  Future<void> updateQuiz(QuizModel quiz) async {
    try {
      // Start loading
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
            message: 'Please select a category before updating the quiz.');
        return;
      }

      // Update quiz data
      quiz.title = title.text.trim();
      quiz.description = description.text.trim();
      quiz.timer = timer.text.isEmpty ? 0 : int.parse(timer.text.trim());
      quiz.categoryId = selectedCategory.value.id;
      quiz.updatedAt = DateTime.now();

      // Call repository to update the quiz
      await quizRepository.updateQuiz(quiz);

      // Reset Form
      resetFields();

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Success message
      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'Quiz has been updated.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
