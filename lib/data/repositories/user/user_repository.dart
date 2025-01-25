import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/setting/models/user_model.dart';
import '../../../utils/exceptions/supabase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';

/// Repository class for user-related operations.
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Function to save user data to Supabase.
  Future<void> createUser(UserModel user) async {
    try {
      print('Inserting user: ${user.toJson()}');
      final response = await _supabase.from('users').insert(user.toJson());
      print('Insert response: $response');
    } catch (e) {
      print('Error while creating user: $e');
      rethrow;
    }
  }

  /// Function to fetch all users except admins
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .neq('Role', 'admin')
          .order('FirstName');

      return response.map((doc) => UserModel.fromJson(doc)).toList();
    } on PostgrestException catch (e) {
      throw TSupabaseException(e.message).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      if (kDebugMode) print('Something Went Wrong: $e');
      throw 'Something Went Wrong: $e';
    }
  }

  /// Function to fetch user details based on user ID.
  Future<UserModel> fetchUserDetails(String id) async {
    try {
      final response =
          await _supabase.from('users').select().eq('id', id).single();

      if (response != null) {
        return UserModel.fromJson(response);
      } else {
        return UserModel.empty();
      }
    } on PostgrestException catch (e) {
      throw TSupabaseException(e.message).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      if (kDebugMode) print('Something Went Wrong: $e');
      throw 'Something Went Wrong: $e';
    }
  }

  /// Function to fetch admin details
  Future<UserModel> fetchAdminDetails() async {
    try {
      final response = await _supabase
          .from('admins')
          .select()
          .eq('id', AuthenticationRepository.instance.authUser!.id)
          .single();

      if (response != null) {
        return UserModel.fromJson(response);
      } else {
        return UserModel.empty();
      }
    } on PostgrestException catch (e) {
      throw TSupabaseException(e.message).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      if (kDebugMode) print('Something Went Wrong: $e');
      throw 'Something Went Wrong: $e';
    }
  }

  /// Function to update user data in Supabase
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _supabase
          .from('users')
          .update(updatedUser.toJson())
          .eq('id', updatedUser.id!);
    } on PostgrestException catch (e) {
      throw TSupabaseException(e.message).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Update any field in specific Users table
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _supabase
          .from('users')
          .update(json)
          .eq('id', AuthenticationRepository.instance.authUser!.id);
    } on PostgrestException catch (e) {
      throw TSupabaseException(e.message).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Delete User Data
  Future<void> deleteUser(String id) async {
    try {
      await _supabase.from('users').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw TSupabaseException(e.message).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
