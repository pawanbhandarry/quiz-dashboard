import 'package:dashboard/data/repositories/quizes/quiz_repository.dart';
import 'package:get/get.dart';

import '../../../data/abstract/base_data_table_controller.dart';

import '../models/quizes_models.dart';

class QuizController extends TBaseController<QuizModel> {
  static QuizController get instance => Get.find();
  final RxList<QuizModel> quizes = <QuizModel>[].obs;
  final _quizRepository = Get.put(QuizRepository());
  @override
  void onInit() {
    super.onInit();
    loadQuizes();
  }

  Future<void> loadQuizes() async {
    try {
      final quizes = await fetchItems();
      allItems.assignAll(quizes);
      print('Fetched Quizes Count: ${quizes.length}');
    } catch (e) {
      print('Failed to load quizes: $e');
    }
  }

  @override
  Future<void> deleteItem(QuizModel item) async {
    await _quizRepository.deleteQuiz(item.id);
  }

  @override
  Future<List<QuizModel>> fetchItems() async {
    return await _quizRepository.getAllQuizzes();
  }

  @override
  bool containsSearchQuery(QuizModel item, String query) {
    return item.title.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending,
        (QuizModel category) => category.title.toLowerCase());
  }
}
