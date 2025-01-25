import 'package:dashboard/features/quizes/models/quizes_models.dart';
import 'package:get/get.dart';

import '../../../data/abstract/base_data_table_controller.dart';
import '../../../data/repositories/categories/category_repository.dart';
import '../models/category_model.dart';

class CategoryController extends TBaseController<CategoryModel> {
  static CategoryController get instance => Get.find();
  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  final _categoryRepository = Get.put(CategoryRepository());
  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final categories = await fetchItems();
      allItems.assignAll(categories);
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  @override
  Future<void> deleteItem(CategoryModel item) async {
    await _categoryRepository.deleteCategory(item.id);
  }

  @override
  Future<List<CategoryModel>> fetchItems() async {
    try {
      final categories = await _categoryRepository.getAllCategories();
      print('Fetched Categories Count: ${categories.length}');
      return categories;
    } catch (e) {
      print('Category Fetch Error: $e');
      return [];
    }
  }

  @override
  bool containsSearchQuery(CategoryModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending,
        (CategoryModel category) => category.name.toLowerCase());
  }

// When setting selected category
}
