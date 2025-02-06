import 'package:dashboard/data/repositories/quizes/quiz_repository.dart';
import 'package:dashboard/data/repositories/user/user_repository.dart';
import 'package:dashboard/utils/popups/full_screen_loader.dart';
import 'package:dashboard/utils/helpers/network_manager.dart';
import 'package:dashboard/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/activation_code/activation_code_repository.dart';
import '../../quizes/models/quizes_models.dart';
import '../../quizes/controller/quiz_controller.dart';
import '../../user/models/user_models.dart';
import '../models/activation_code_model.dart';

class EditActivationCodeController extends GetxController {
  static EditActivationCodeController get instance => Get.find();

  // Form Key
  final formKey = GlobalKey<FormState>();

  // Selected Quiz
  final selectedQuiz = QuizModel.empty().obs;

  // Text Controllers

  final expiresAtController = TextEditingController();
  final codeController = TextEditingController();
  final searchController = TextEditingController();

  // Repository instances
  late final ActivationCodeRepository _activationCodeRepository;
  late final UserRepository _userRepository;

  // Observables
  final loading = false.obs;
  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxList<UserModel> filteredUsers = <UserModel>[].obs;
  final RxList<UserModel> selectedUsers = <UserModel>[].obs;
  final RxSet<String> selectedUserIds = <String>{}.obs;
  var usageLimit = 'Single'.obs; // Default value
  @override
  void onInit() {
    super.onInit();

    final QuizController quizController = Get.put(QuizController());
    quizController.loadQuizes();

    _activationCodeRepository = Get.put(ActivationCodeRepository());
    _userRepository = Get.put(UserRepository());

    fetchUsers();
  }

  void init(ActivationCodeModel activationCode) {
    // Ensure quizes are loaded before processing
    final quizController = QuizController.instance;
    if (quizController.allItems.isEmpty) {
      quizController.loadQuizes().then((_) {
        loadActivationCodeData(activationCode);
      });
    } else {
      loadActivationCodeData(activationCode);
    }
  }

  // Method to load existing activation code data into the form
  void loadActivationCodeData(ActivationCodeModel code) {
    codeController.text = code.code;
    usageLimit.value = code.usageLimit;
    if (code.expiresAt != null) {
      expiresAtController.text = code.expiresAt!.toIso8601String();
    }

    // Find and set the matching quiz
    final matchingQuiz = QuizController.instance.allItems.firstWhere(
      (item) => item.id == code.quizId,
      orElse: () => QuizModel.empty(),
    );
    selectedQuiz.value = matchingQuiz;
    print('Matching Quiz: ${matchingQuiz.title}');
    selectedUserIds.clear();
    selectedUsers.clear();

    // Load restricted users
    loadRestrictedUsers(code.restrictedEmails!, code);
  }

  /// Fetch all users from Supabase
  Future<void> fetchUsers() async {
    final users = await _userRepository.getAllUsers();
    allUsers.assignAll(users);
    filteredUsers.assignAll(users);
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(allUsers);
    } else {
      filteredUsers.assignAll(
        allUsers.where((user) =>
            user.email.toLowerCase().contains(query.toLowerCase()) ||
            user.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  void toggleUserSelection(UserModel user) {
    if (selectedUserIds.contains(user.id)) {
      selectedUsers.removeWhere((selected) => selected.id == user.id);
      selectedUserIds.remove(user.id);
    } else {
      selectedUsers.add(user);
      selectedUserIds.add(user.id!);
    }
    selectedUsers.refresh(); // Ensures UI updates
    selectedUserIds.refresh(); // Also refresh this observable
    print("Selected Users: ${selectedUsers.map((u) => u.email).toList()}");
  }

  /// Update Activation Code
  Future<void> updateActivationCode(String codeId) async {
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

      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (selectedQuiz.value.id.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'Quiz Required',
            message:
                'Please select a quiz before updating the activation code.');
        return;
      }

      final updatedCode = ActivationCodeModel(
        id: codeId,
        quizId: selectedQuiz.value.id,
        code: codeController.text.trim(),
        usageLimit: usageLimit.value,
        expiresAt: expiresAtController.text.isNotEmpty
            ? DateTime.parse(expiresAtController.text.trim())
            : null,
        status: 'active',
        restrictedEmails: selectedUsers.map((user) => user.email).toList(),
      );

      await _activationCodeRepository.updateActivationCode(updatedCode);

      // Success Message
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
          title: 'Success', message: 'Activation Code has been updated.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  /// Select Expiration Date
  Future<void> selectExpirationDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      expiresAtController.text = pickedDate.toIso8601String();
    }
  }

  Future<void> loadRestrictedUsers(
      List<String> emails, ActivationCodeModel code) async {
    try {
      final users = await _userRepository.getAllUsers();
      final restrictedUsers = users
          .where((user) => code.restrictedEmails!.contains(user.email))
          .toList();
      selectedUsers.assignAll(restrictedUsers);
      selectedUserIds
          .addAll(restrictedUsers.map((user) => user.id!).whereType<String>());
    } catch (e) {
      print('Error loading restricted users: $e');
    }
  }

  bool isUserSelected(String userId) {
    return selectedUserIds.contains(userId);
  }

  void _clearForm() {
    codeController.clear();
    usageLimit.value = 'Single';
    expiresAtController.clear();
    selectedQuiz.value = QuizModel.empty();
    selectedUsers.clear();
    searchController.clear();
  }

  @override
  void onClose() {
    codeController.dispose();
    expiresAtController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
