import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/routes.dart';
import '../../../utils/exceptions/supabase_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final _auth = Supabase.instance.client.auth;

  // Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  // Get IsAuthenticated User
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  void onReady() {
    super.onReady();
    // Listen to auth state changes
    _auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        screenRedirect();
      } else if (data.event == AuthChangeEvent.signedOut) {
        Get.offAllNamed(TRoutes.login);
      }
    });
  }

  // Function to determine the relevant screen and redirect accordingly
  void screenRedirect() async {
    final user = _auth.currentUser;
    if (user != null) {
      Get.offAllNamed(TRoutes.dashboard);
    } else {
      Get.offAllNamed(TRoutes.login);
    }
  }

  // LOGIN
  Future<AuthResponse> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // REGISTER
  Future<AuthResponse> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // REGISTER USER BY ADMIN
  Future<AuthResponse> registerUserByAdmin(
      String email, String password) async {
    try {
      // In Supabase, admin can create users through the same signUp method
      final response = await _auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      // Note: Supabase handles email verification automatically when configured
      // You can customize this in the Supabase dashboard
      throw 'Email verification is handled automatically by Supabase';
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // FORGET PASSWORD
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // RE AUTHENTICATE USER
  Future<void> reAuthenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      // Supabase doesn't have direct re-authentication
      // We can sign in again to verify credentials
      await _auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Logout User
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed(TRoutes.login);
    } on AuthException catch (e) {
      if (kDebugMode) print(e);
      throw e.message;
    } catch (e) {
      if (kDebugMode) print(e);
      throw 'Something went wrong. Please try again';
    }
  }

  // DELETE USER
  Future<void> deleteAccount() async {
    try {
      // First, get the user data to check if they're authenticated
      final user = _auth.currentUser;
      if (user == null) throw 'No authenticated user found';

      // Delete user from Supabase auth
      final response = await Supabase.instance.client
          .rpc('delete_user', params: {'user_id': user.id});

      if (response.error != null) {
        throw response.error!.message;
      }
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
