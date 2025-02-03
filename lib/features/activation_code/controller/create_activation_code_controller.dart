import 'package:dashboard/data/repositories/quizes/quiz_repository.dart';
import 'package:dashboard/data/repositories/user/user_repository.dart';
import 'package:dashboard/utils/popups/full_screen_loader.dart';
import 'package:dashboard/utils/helpers/network_manager.dart';
import 'package:dashboard/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/activation_code/activation_code_repository.dart';
import '../../quizes/models/quizes_models.dart';
import '../../user/models/user_models.dart';
import '../models/activation_code_model.dart';

class CreateActivationCodeController extends GetxController {
  static CreateActivationCodeController get instance => Get.find();
  final selectedQuiz = QuizModel.empty().obs;

  final loading = false.obs;
  var usageLimit = 'Single'.obs; // Default value
  final expiresAtController = TextEditingController();
  final codeController = TextEditingController(); // Added for manual input
  final restrictedEmailsController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late final ActivationCodeRepository activationCodeRepository;
  late final UserRepository userRepository;
  late final QuizRepository quizRepository;
  final RxList<UserModel> allUsers = <UserModel>[].obs; // All users list
  final RxList<UserModel> filteredUsers = <UserModel>[].obs; // Filtered list
  final RxList<UserModel> selectedUsers =
      <UserModel>[].obs; // Selected users list
  final TextEditingController searchController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    activationCodeRepository = Get.put(ActivationCodeRepository());
    quizRepository = Get.put(QuizRepository());
    userRepository = Get.put(UserRepository());

    fetchUsers(); // Load users when controller is initialized
  }

  /// Fetch all users from Supabase
  Future<void> fetchUsers() async {
    final users = await UserRepository.instance.getAllUsers();
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
            user.firstName.toLowerCase().contains(query.toLowerCase()) ||
            user.lastName.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  /// Toggle user selection for restriction
  void toggleUserSelection(UserModel user) {
    if (selectedUsers.any((selected) => selected.id == user.id)) {
      selectedUsers.removeWhere((selected) => selected.id == user.id);
    } else {
      selectedUsers.add(user);
    }
    print("Selected Users: ${selectedUsers.map((u) => u.email).toList()}");
    selectedUsers.refresh(); // 🔥 Force UI update
  }

  /// Reset Fields
  void resetFields() {
    selectedQuiz.value = QuizModel.empty();
    loading(false);
    usageLimit.value = 'Single';
    expiresAtController.clear();
    codeController.clear();
    selectedUsers.clear();
  }

  /// Create Activation Code with Selected Users
  Future<void> createActivationCode() async {
    try {
      TFullScreenLoader.popUpCircular();

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'No Internet', message: 'Check your connection.');
        return;
      }

      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'Error', message: 'Please fill all fields.');
        return;
      }
      if (selectedQuiz.value.id.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'Quiz Required', message: 'Please select a quiz ');
        return;
      }

      final generatedCode = codeController.text.isNotEmpty
          ? codeController.text.trim()
          : generateUniqueCode();
      // 🔍 **Check if quiz ID already exists**
      bool quizExists =
          await activationCodeRepository.doesQuizIdExist(selectedQuiz.value.id);
      if (quizExists) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'Error',
            message: 'An activation code for this quiz already exists.');
        return;
      }

      // Extract selected user emails
      List<String> restrictedEmails =
          selectedUsers.map((user) => user.email).toList();
      print('Selected Users:$restrictedEmails');

      final newCode = ActivationCodeModel(
        id: '',
        quizId: selectedQuiz.value.id,
        code: generatedCode,
        usageLimit: usageLimit.value,
        expiresAt: expiresAtController.text.isNotEmpty
            ? DateTime.parse(expiresAtController.text.trim())
            : null,
        status: 'active',
        restrictedEmails: selectedUsers.map((user) => user.email).toList(),
      );

      await activationCodeRepository.createActivationCode(newCode);

      resetFields();
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
          title: 'Success', message: 'Activation Code Created.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Generate a unique activation code
  String generateUniqueCode() {
    return DateTime.now().millisecondsSinceEpoch.toString();
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
}
