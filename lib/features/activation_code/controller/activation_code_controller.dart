import 'package:get/get.dart';
import '../../../data/abstract/base_data_table_controller.dart';
import '../../../data/repositories/activation_code/activation_code_repository.dart';
import '../models/activation_code_model.dart';

class ActivationCodeController extends TBaseController<ActivationCodeModel> {
  static ActivationCodeController get instance => Get.find();
  final RxList<ActivationCodeModel> activationCodes =
      <ActivationCodeModel>[].obs;
  final _activationCodeRepository = Get.put(ActivationCodeRepository());

  @override
  void onInit() {
    super.onInit();
    loadActivationCodes();
  }

  Future<void> loadActivationCodes() async {
    try {
      final codes = await fetchItems();
      allItems.assignAll(codes);
      print('Fetched Activation Codes Count: ${allItems.length}');
    } catch (e) {
      print('Failed to load activation codes: $e');
    }
  }

  @override
  Future<void> deleteItem(ActivationCodeModel item) async {
    await _activationCodeRepository.deleteActivationCode(item.id);
  }

  @override
  Future<List<ActivationCodeModel>> fetchItems() async {
    return await _activationCodeRepository.getAllActivationCodes();
  }

  @override
  bool containsSearchQuery(ActivationCodeModel item, String query) {
    return item.code.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByCode(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending,
        (ActivationCodeModel code) => code.code.toLowerCase());
  }

  /// Create a new activation code
  Future<void> createActivationCode(ActivationCodeModel newCode) async {
    try {
      await _activationCodeRepository.createActivationCode(newCode);
      loadActivationCodes();
    } catch (e) {
      print('Failed to create activation code: $e');
    }
  }

  /// Edit an existing activation code
  Future<void> editActivationCode(ActivationCodeModel updatedCode) async {
    try {
      await _activationCodeRepository.updateActivationCode(updatedCode);
      loadActivationCodes();
    } catch (e) {
      print('Failed to update activation code: $e');
    }
  }
}
