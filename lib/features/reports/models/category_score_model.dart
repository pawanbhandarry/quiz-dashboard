class CategoryScoreModel {
  final String categoryId;
  final int totalMaxScore;
  final int totalActualScore;
  final List<dynamic> quizScores;
  final int participantsCount;

  CategoryScoreModel({
    required this.categoryId,
    required this.totalMaxScore,
    required this.totalActualScore,
    required this.quizScores,
    required this.participantsCount,
  });

  // Calculated property for overall performance percentage
  double get performancePercentage =>
      totalMaxScore > 0 ? (totalActualScore / totalMaxScore) * 100 : 0;

  // Factory constructor for JSON parsing
  factory CategoryScoreModel.fromJson(Map<String, dynamic> json) {
    return CategoryScoreModel(
      categoryId: json['category_id'] ?? '',
      totalMaxScore: json['total_max_score'] ?? 0,
      totalActualScore: json['total_actual_score'] ?? 0,
      quizScores: json['quiz_scores'] ?? [],
      participantsCount: json['participants_count'] ?? 0,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'total_max_score': totalMaxScore,
      'total_actual_score': totalActualScore,
      'quiz_scores': quizScores,
      'participants_count': participantsCount,
    };
  }
}
