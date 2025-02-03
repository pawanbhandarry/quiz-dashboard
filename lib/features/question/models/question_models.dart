import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionModel {
  String id;
  String question;
  Map<String, String> options;
  String correctAnswer;
  String explanation;
  String? imageUrl;
  String quizId;
  String categoryId;
  String? quizName; // Will be fetched dynamically
  String? categoryName; // Will be fetched dynamically

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.quizId,
    required this.categoryId,
    this.quizName,
    this.categoryName,
    this.imageUrl,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> data) {
    return QuestionModel(
      id: data['id'],
      question: data['question'],
      options: {
        'A': data['option_a'],
        'B': data['option_b'],
        'C': data['option_c'],
        'D': data['option_d'],
      },
      correctAnswer: data['correct_answer'],
      explanation: data['explanation'],
      imageUrl: data['image_url'],
      quizId: data['quiz_id'],
      categoryId: data['category_id'],
      quizName: data['quiz_name'], // Dynamically fetched
      categoryName: data['category_name'], // Dynamically fetched
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'option_a': options['A'],
      'option_b': options['B'],
      'option_c': options['C'],
      'option_d': options['D'],
      'correct_answer': correctAnswer,
      'explanation': explanation,
      'image_url': imageUrl,
      'quiz_id': quizId,
      'category_id': categoryId,
    };
  }
}
