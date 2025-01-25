import 'package:dashboard/data/repositories/questions/questions_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../quizes/controller/quiz_controller.dart';
import '../../quizes/models/quizes_models.dart';
import '../models/question_models.dart';

class EditQuestionController extends GetxController {
  static EditQuestionController get instance => Get.find();
  // Form Key
  final formKey = GlobalKey<FormState>();

  final selectedQuiz = QuizModel.empty().obs;
  // Text Controllers
  final questionController = TextEditingController();
  final optionAController = TextEditingController();
  final optionBController = TextEditingController();
  final optionCController = TextEditingController();
  final optionDController = TextEditingController();
  final explanationController = TextEditingController();
  final imageUrlController = TextEditingController();

  // Observables
  Rx<String> correctAnswer = ''.obs;
  var correctAnswerKey = ''.obs;

  final loading = false.obs;
  late final QuestionRepository _questionRepository;

  @override
  void onInit() {
    super.onInit();

    final QuizController quizController = Get.put(QuizController());
    quizController.loadQuizes();

    _questionRepository = Get.put(QuestionRepository());
  }

  void init(QuestionModel quiz) {
    // Ensure categories are loaded before processing
    final quizController = QuizController.instance;
    if (quizController.allItems.isEmpty) {
      quizController.loadQuizes().then((_) {
        loadQuestionData(quiz);
      });
    } else {
      loadQuestionData(quiz);
    }
  }

  // Method to load existing question data into the form
  void loadQuestionData(QuestionModel question) {
    questionController.text = question.question;
    optionAController.text = question.options['A'] ?? '';
    optionBController.text = question.options['B'] ?? '';
    optionCController.text = question.options['C'] ?? '';
    optionDController.text = question.options['D'] ?? '';
    explanationController.text = question.explanation;
    imageUrlController.text = question.imageUrl ?? '';
    correctAnswer.value = question.correctAnswer;
    correctAnswerKey.value = _mapCorrectAnswerToKey(question.correctAnswer);
    final matchingQuiz = QuizController.instance.allItems.firstWhere(
      (item) => item.id == question.quizId,
      orElse: () => QuizModel.empty(),
    );
    selectedQuiz.value = matchingQuiz;
    print('Matching Category: ${matchingQuiz.title}');
  }

  // Map correctAnswer value back to key (A, B, C, D)
  String _mapCorrectAnswerToKey(String answer) {
    if (answer == optionAController.text) return 'A';
    if (answer == optionBController.text) return 'B';
    if (answer == optionCController.text) return 'C';
    if (answer == optionDController.text) return 'D';
    return '';
  }

  // Image Picking Method
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageUrlController.text =
          image.path; // Save the image path in the controller
    }
  }

  // Method to edit an existing question
  Future<void> editQuestion(String questionId) async {
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
      if (selectedQuiz.value.id.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'Quiz Required',
            message: 'Please select a quiz before updating the question.');
        return;
      }
      // Create updated question model
      final question = QuestionModel(
        id: questionId,
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
      await _questionRepository.updateQuestion(question);

      // Success Message & Redirect
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
          title: 'Success', message: 'Question has been updated.');
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
