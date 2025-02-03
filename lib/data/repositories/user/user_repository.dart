import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/user/models/user_models.dart';
import '../../../utils/exceptions/supabase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
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
      final response =
          await _supabase.from('users').select().order('first_name');

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

  //fetch top users
  Future<List<UserModel>> getTopUsers({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .order('score', ascending: false) // Order by score (Descending)
          .limit(limit); // Get top 10 users

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

// Change Status
  Future<void> toggleUserStatus(String userId, String currentStatus) async {
    try {
      String newStatus = currentStatus == 'active' ? 'inactive' : 'active';

      await _supabase
          .from('users')
          .update({'status': newStatus}).eq('id', userId);
    } on PostgrestException catch (e) {
      throw TSupabaseException(e.message).message;
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

  // Add this method
  Future<List<UserModel>> getUsersByEmails(List<String> emails) async {
    try {
      if (emails.isEmpty) return [];

      final response =
          await _supabase.from('users').select().contains('email', emails);

      return (response as List)
          .map((user) => UserModel.fromJson(user))
          .toList();
    } catch (e) {
      throw 'Error fetching users by emails: $e';
    }
  }
}
