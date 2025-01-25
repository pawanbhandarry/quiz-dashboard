import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/category/models/category_model.dart';
import '../../../utils/exceptions/supabase_exceptions.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tableName = 'categories';

  // Helper method to check authentication
  void _checkAuth() {
    final session = _supabase.auth.currentSession;
    if (session == null) {
      throw 'User not authenticated';
    }
  }

  // Create a new category
  Future<String> createCategory(CategoryModel category) async {
    try {
      // Check authentication before proceeding
      _checkAuth();
      final response = await _supabase
          .from(_tableName)
          .insert({
            'name': category.name,
            'description': category.description,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
            'noof_quizes': 0,
          })
          .select()
          .single();

      print('Insert response: $response'); // Debug log

      if (response == null) {
        throw 'Failed to create category: No response';
      }
      print('response: ${response['id']}');
      return response['id'].toString();
    } on PostgrestException catch (e) {
      print(
          'Postgrest Error: ${e.message}, Code: ${e.code}, Details: ${e.details}');
      if (e.code == '42501') {
        throw 'Permission denied. Please check if you are properly authenticated.';
      }
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      _checkAuth();

      final List<dynamic> response = await _supabase.from(_tableName).select();

      return response
          .map((category) => CategoryModel.fromJson(category))
          .toList();
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Update an existing category
  Future<void> updateCategory(CategoryModel category) async {
    try {
      _checkAuth();

      await _supabase.from(_tableName).update({
        'name': category.name,
        'description': category.description,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', category.id);
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      _checkAuth();

      await _supabase.from(_tableName).delete().eq('id', categoryId);
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      throw 'Database error: ${e.message}';
    } catch (e) {
      print('Unexpected error: $e');
      throw 'Something went wrong. Please try again';
    }
  }
}
