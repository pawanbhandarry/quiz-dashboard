import 'package:intl/intl.dart';

class QuizScoreModel {
  final String id;
  final String userId;
  final String quizId;
  final int totalScore;
  final int maximumScore;
  final DateTime createdAt;
  final String userName;
  final String quizTitle;
  final String quizCategoryId;
  final String quizCategoryName;

  QuizScoreModel({
    this.id = '',
    required this.userId,
    required this.quizId,
    required this.totalScore,
    required this.maximumScore,
    DateTime? createdAt,
    required this.userName,
    required this.quizTitle,
    required this.quizCategoryId,
    required this.quizCategoryName,
  }) : createdAt = createdAt ?? DateTime.now();

  // Calculated property for score percentage
  double get scorePercentage =>
      maximumScore > 0 ? (totalScore / maximumScore) * 100 : 0;

  // Formatted date for display
  String get formattedDate => DateFormat('dd MMM yyyy HH:mm').format(createdAt);

  // From JSON constructor
  factory QuizScoreModel.fromJson(Map<String, dynamic> json) {
    return QuizScoreModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      quizId: json['quiz_id']?.toString() ?? '',
      totalScore: int.tryParse(json['total_score']?.toString() ?? '0') ?? 0,
      maximumScore: int.tryParse(json['maximum_score']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      userName: json['user']?['name'],
      quizCategoryName: json['quizes']?['category_name'],
      quizTitle: json['quizzes']?['title'],
      quizCategoryId: json['quizzes']?['category_id'],
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'quiz_id': quizId,
      'total_score': totalScore,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
