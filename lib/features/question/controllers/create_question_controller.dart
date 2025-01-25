// Controller for managing question creation
import 'package:dashboard/data/repositories/questions/questions_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../quizes/models/quizes_models.dart';
import '../models/question_models.dart';

class CreateQuestionController extends GetxController {
  static CreateQuestionController get instance => Get.find();
  // Form Key
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final questionController = TextEditingController();
  final optionAController = TextEditingController();
  final optionBController = TextEditingController();
  final optionCController = TextEditingController();
  final optionDController = TextEditingController();
  final explanationController = TextEditingController();
  final imageUrlController = TextEditingController();

  // Observables
  Rx<QuizModel> selectedQuiz = QuizModel.empty().obs;
  Rx<String> correctAnswer = ''.obs;
  var correctAnswerKey = ''.obs; // To store the selected key (A, B, C, D)

  Rx<bool> loading = false.obs;
  late final QuestionRepository _questionRepository;
  @override
  void onInit() {
    super.onInit();
    _questionRepository = Get.put(QuestionRepository());
  }

  // Image Picking Method (You'll need to implement this based on your image picking logic)
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageUrlController.text =
          image.path; // Save the image path in the controller
    }
  }

  // Method to create a question
  Future<void> createQuestion() async {
    try {
      TFullScreenLoader.popUpCircular();
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
      // Create question model
      final question = QuestionModel(
        id: '',
        question: questionController.text.trim(),
        options: {
          'A': optionAController.text.trim(),
          'B': optionBController.text.trim(),
          'C': optionCController.text.trim(),
          'D': optionDController.text.trim(),
        },
        correctAnswer: correctAnswer.value,
        explanation: explanationController.text.trim(),
        quizId: selectedQuiz.value.id,
        quizName: selectedQuiz.value.title,
        imageUrl: imageUrlController.text.trim().isNotEmpty
            ? imageUrlController.text.trim()
            : null,
      );
      question.id = await _questionRepository.createQuestion(question);

      // Clear form after successful creation
      _clearForm();
      TFullScreenLoader.stopLoading();

      // Success Message & Redirect
      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'New Question has been Added.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  // Clear form method
  void _clearForm() {
    questionController.clear();
    optionAController.clear();
    optionBController.clear();
    optionCController.clear();
    optionDController.clear();
    explanationController.clear();
    imageUrlController.clear();
    selectedQuiz.value = QuizModel.empty();
    correctAnswer.value = '';
    correctAnswerKey.value = '';
  }

  @override
  void onClose() {
    questionController.dispose();
    optionAController.dispose();
    optionBController.dispose();
    optionCController.dispose();
    optionDController.dispose();
    explanationController.dispose();
    imageUrlController.dispose();
    super.onClose();
  }
}
