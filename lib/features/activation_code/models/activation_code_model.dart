import 'dart:convert';

class ActivationCodeModel {
  String id;
  final String quizId;
  final String code;
  final String usageLimit;

  final DateTime? expiresAt;
  final List<String>? restrictedEmails;

  final String status;
  String? quizName;

  ActivationCodeModel({
    required this.id,
    required this.quizId,
    required this.code,
    required this.usageLimit,
    this.expiresAt,
    this.quizName,
    this.restrictedEmails,
    required this.status,
  });

  factory ActivationCodeModel.fromJson(Map<String, dynamic> json) {
    return ActivationCodeModel(
      id: json['id'],
      quizId: json['quiz_id'],
      code: json['code'],
      usageLimit: json['usage_limit'],

      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,

      status: json['status'],
      quizName: json['quizes'] != null
          ? json['quizes']['title']
          : null, // Fetching quiz name dynamically
      restrictedEmails: json['restricted_emails'] != null
          ? List<String>.from(json['restricted_emails'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'code': code,
      'usage_limit': usageLimit,
      'expires_at': expiresAt?.toIso8601String(),
      'status': status,
      'restricted_emails': restrictedEmails,
    };
  }

  static ActivationCodeModel empty() => ActivationCodeModel(
        id: '',
        quizId: 'quizId',
        code: '',
        usageLimit: '',
        status: '',
      );
}
