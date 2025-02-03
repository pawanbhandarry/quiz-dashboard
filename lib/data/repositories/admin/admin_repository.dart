import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/setting/models/admin_model.dart';
import '../../../utils/exceptions/supabase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';

/// Repository class for user-related operations.
class AdminRepository extends GetxController {
  static AdminRepository get instance => Get.find();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Function to save user data to Supabase.
  Future<void> createUser(AdminModel user) async {
    try {
      print('Inserting user: ${user.toJson()}');
      final response = await _supabase.from('admins').insert(user.toJson());
      print('Insert response: $response');
    } catch (e) {
      print('Error while creating user: $e');
      rethrow;
    }
  }

  /// Function to fetch all admins except admins
  Future<List<AdminModel>> getAllUsers() async {
    try {
      final response = await _supabase
          .from('admins')
          .select()
          .neq('Role', 'admin')
          .order('FirstName');

      return response.map((doc) => AdminModel.fromJson(doc)).toList();
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
  Future<AdminModel> fetchUserDetails(String id) async {
    try {
      final response =
          await _supabase.from('admins').select().eq('id', id).single();

      if (response != null) {
        return AdminModel.fromJson(response);
      } else {
        return AdminModel.empty();
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
  Future<AdminModel> fetchAdminDetails() async {
    try {
      final response = await _supabase
          .from('admins')
          .select()
          .eq('id', AuthenticationRepository.instance.authUser!.id)
          .single();

      if (response != null) {
        return AdminModel.fromJson(response);
      } else {
        return AdminModel.empty();
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
  Future<void> updateUserDetails(AdminModel updatedUser) async {
    try {
      await _supabase
          .from('admins')
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
          .from('admins')
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
      await _supabase.from('admins').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw TSupabaseException(e.message).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
