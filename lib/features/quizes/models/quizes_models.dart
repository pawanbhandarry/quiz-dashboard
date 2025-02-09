import '../../../utils/formatters/formatter.dart';

class QuizModel {
  String id;
  String categoryId; // Links the quiz to a specific category
  String title;
  String description;
  int timer; // Timer in minutes (e.g., 20, 30)
  String shareableCode;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? categoryName; // Fetched from the categories table
  int noofQuestions;

  QuizModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    this.timer = 0, // Default timer value is 0
    this.noofQuestions = 0,
    required this.shareableCode,
    this.createdAt,
    this.updatedAt,
    this.categoryName, // Now nullable since it's fetched dynamically
  });

  /// Getters for formatted dates
  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  /// Empty Helper Function
  static QuizModel empty() => QuizModel(
        id: '',
        categoryId: '',
        title: '',
        description: '',
        timer: 0,
        shareableCode: '',
      );

  /// Convert model to JSON structure for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'timer': timer,
      'shareable_code': shareableCode,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  /// Factory constructor to create a QuizModel from Supabase JSON data
  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] ?? '',
      categoryId: json['category_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      timer: json['timer'] ?? 0,
      noofQuestions: json['no_of_questions'] ?? 0,
      shareableCode: json['shareable_code'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      categoryName: json['categories'] != null
          ? json['categories']['name']
          : null, // Fetching category name dynamically
    );
  }
}
