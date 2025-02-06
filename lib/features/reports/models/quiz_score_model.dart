import '../../../utils/formatters/formatter.dart';

class QuizScoreModel {
  String id;
  String userId;
  String quizId;
  String categoryId;
  int score;
  int incorrectAnswers;
  int totalScore;
  int timeTaken;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Additional fields from related tables
  String? userName;
  String? quizTitle;
  String? categoryName;

  QuizScoreModel({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.categoryId,
    this.totalScore = 0,
    this.score = 0,
    this.incorrectAnswers = 0,
    this.timeTaken = 0,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.quizTitle,
    this.categoryName,
  });

  /// Getters for formatted dates
  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  /// Convert model to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'quiz_id': quizId,
      'category_id': categoryId,
      'score': score,
      'time_taken': timeTaken,
      'incorrect_answers': incorrectAnswers,
      'total_score': totalScore,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  /// Factory constructor to create a QuizScoreModel from Supabase JSON
  factory QuizScoreModel.fromJson(Map<String, dynamic> json) {
    return QuizScoreModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      quizId: json['quiz_id'] ?? '',
      categoryId: json['category_id'] ?? '',
      score: json['score'] ?? 0,
      totalScore: json['total_score'] ?? 0,
      incorrectAnswers: json['incorrect_answers'] ?? 0,
      timeTaken: json['time_taken'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      userName: json['users'] != null && json['users']['name'] != null
          ? "${json['users']['name']}"
          : null,
      quizTitle: json['quizes'] != null && json['quizes']['title'] != null
          ? json['quizes']['title']
          : null, // Add null check here
      categoryName:
          json['categories'] != null && json['categories']['name'] != null
              ? json['categories']['name']
              : null, // Add null check here
    );
  }
}
