import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/activation_code/models/activation_code_model.dart';

class ActivationCodeRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get all activation codes
  Future<List<ActivationCodeModel>> getAllActivationCodes() async {
    final response =
        await _supabase.from('activation_codes').select('*, quizes(title)');
    return response.map((code) => ActivationCodeModel.fromJson(code)).toList();
  }

  /// Create a new activation code
  Future<String> createActivationCode(ActivationCodeModel code) async {
    final response = await _supabase
        .from('activation_codes')
        .insert({
          'quiz_id': code.quizId,
          'code': code.code,
          'usage_limit': code.usageLimit,
          'expires_at': code.expiresAt?.toIso8601String(),
          'status': code.status,
          'restricted_emails': code.restrictedEmails,
        })
        .select()
        .single();

    if (response == null) {
      throw Exception('Failed to create activation code.');
    }
    print('Created Activation Code ID: ${response['id']}');

    return response['id']
        .toString(); // Return the newly created activation code's ID
  }

  /// Update an existing activation code
  Future<void> updateActivationCode(ActivationCodeModel code) async {
    await _supabase
        .from('activation_codes')
        .update(code.toJson())
        .eq('id', code.id);
  }

  /// Delete an activation code
  Future<void> deleteActivationCode(String id) async {
    await _supabase.from('activation_codes').delete().eq('id', id);
  }

  Future<bool> doesQuizIdExist(String quizId) async {
    final response = await _supabase
        .from('activation_codes')
        .select('quiz_id')
        .eq('quiz_id', quizId)
        .maybeSingle(); // 🔍 Fetches a single record if exists

    return response != null;
  }

  Future<ActivationCodeModel> getActivationCodeById(String id) async {
    try {
      final response = await _supabase
          .from('activation_codes')
          .select()
          .eq('id', id)
          .single();

      return ActivationCodeModel.fromJson(response);
    } catch (e) {
      throw 'Error fetching activation code: $e';
    }
  }
}
