import 'package:get/get.dart';
import '../../../data/repositories/reports/quiz_score_repository.dart';
import '../models/quiz_score_model.dart';

class LeaderboardController extends GetxController {
  final _scoreRepository = Get.put(QuizScoreRepository());
  final RxList<QuizScoreModel> leaderboard = <QuizScoreModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLeaderboard();
  }

  Future<void> loadLeaderboard() async {
    try {
      leaderboard.assignAll(await _scoreRepository.getLeaderboardScores());
    } catch (e) {
      print('Error loading leaderboard: $e');
    }
  }
}
