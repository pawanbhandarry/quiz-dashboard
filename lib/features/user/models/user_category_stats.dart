class CategoryStats {
  final double averageScore;
  final double highestScore;
  final double lowestScore;
  final int totalAttempts;
  final int passCount;
  final double averageTimeTaken;

  CategoryStats({
    required this.averageScore,
    required this.highestScore,
    required this.lowestScore,
    required this.totalAttempts,
    required this.passCount,
    required this.averageTimeTaken,
  });
}
