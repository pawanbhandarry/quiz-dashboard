import 'package:dashboard/data/repositories/questions/questions_repository.dart';
import 'package:dashboard/data/repositories/quizes/quiz_repository.dart';
import 'package:get/get.dart';

import '../../../data/abstract/base_data_table_controller.dart';
import '../models/question_models.dart';

class QuestionController extends TBaseController<QuestionModel> {
  static QuestionController get instance => Get.find();

  final _questionRepository = Get.put(QuestionRepository());

  @override
  Future<void> deleteItem(QuestionModel item) async {
    await _questionRepository.deleteQuestion(item.id);
  }

  @override
  Future<List<QuestionModel>> fetchItems() async {
    return await _questionRepository.getAllQuestions();
  }

  @override
  bool containsSearchQuery(QuestionModel item, String query) {
    return item.question.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending,
        (QuestionModel question) => question.question.toLowerCase());
  }

  /// Method to delete multiple questions at once
  Future<void> bulkDeleteQuestions(List<QuestionModel> items) async {
    try {
      // Extract question IDs
      final questionIds = items.map((item) => item.id).toList();
      // Call repository method for bulk deletion
      await _questionRepository.bulkDeleteQuestions(questionIds);
    } catch (e) {
      print('Bulk delete error: $e');
      rethrow;
    }
  }
}
