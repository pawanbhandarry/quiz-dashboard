import 'package:dashboard/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/text_strings.dart';
import '../../setting/controllers/admin_controller.dart';
import '../../setting/models/user_model.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// Supabase client instance
  final _supabase = Supabase.instance.client;

  /// Whether the password should be hidden
  final hidePassword = true.obs;

  /// Whether the user has selected "Remember Me"
  final rememberMe = false.obs;

  /// Local storage instance for remembering email and password
  final localStorage = GetStorage();

  /// Text editing controller for the email field
  final email = TextEditingController();

  /// Text editing controller for the password field
  final password = TextEditingController();

  /// Form key for the login form
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // Retrieve stored email and password if "Remember Me" is selected
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  /// Handles email and password sign-in process
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Logging you in...', TImages.ridingIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login user using Email & Password Authentication with Supabase
      final response = await _supabase.auth.signInWithPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      if (response.user == null) {
        throw 'Authentication failed. Please try again.';
      }

      // User Information
      final user = await fetchUserInformation();
      // TLoaders.errorSnackBar(
      //     title: '${user.role}',
      //     message: '${_supabase.auth.currentUser!.email}');
      print(user.role);

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // If user is not admin, logout and return
      if (user.role != AppRole.admin) {
        await _supabase.auth.signOut();
        TLoaders.errorSnackBar(
            title: 'Not Authorized',
            message:
                'You are not authorized or do not have access. Contact Admin');
      } else {
        // Redirect
        AuthenticationRepository.instance.screenRedirect();
      }
    } on AuthException catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Authentication Error', message: e.message);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  /// Handles registration of admin user
  Future<void> registerAdmin() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Registering Admin Account...', TImages.ridingIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Register admin using Supabase Auth
      final response = await _supabase.auth.signUp(
        email: TTexts.adminEmail,
        password: TTexts.adminPassword,
      );

      if (response.user == null) {
        throw 'Failed to create admin account';
      }

      // Create admin record in Supabase
      final userRepository = Get.put(UserRepository());
      await userRepository.createUser(
        UserModel(
          id: response.user!.id,
          firstName: 'App',
          lastName: 'Admin',
          email: TTexts.adminEmail,
          role: AppRole.admin,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } on AuthException catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Registration Error', message: e.message);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      print(e.toString());
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  Future<UserModel> fetchUserInformation() async {
    // Fetch user details and assign to AdminController
    final controller = AdminController.instance;
    UserModel user;
    if (controller.user.value.id == null || controller.user.value.id!.isEmpty) {
      user = await AdminController.instance.fetchUserDetails();
    } else {
      user = controller.user.value;
    }

    return user;
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
