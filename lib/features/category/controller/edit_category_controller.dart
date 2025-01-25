import 'package:dashboard/data/repositories/categories/category_repository.dart';
import 'package:dashboard/features/category/controller/category_controller.dart';
import 'package:dashboard/features/category/models/category_model.dart';
import 'package:dashboard/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/loaders.dart';

class EditCategoryController extends GetxController {
  static EditCategoryController get instance => Get.find();

  final selectedParent = CategoryModel.empty().obs;
  final loading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final description = TextEditingController();
  final formKey = GlobalKey<FormState>();

  /// Init Data
  void init(CategoryModel category) {
    name.text = category.name;
    description.text = category.description;
  }

  /// Method to reset fields
  void resetFields() {
    loading(false);

    // name.clear();
    // description.clear();
  }

  /// Register new Category
  Future<void> updateCategory(CategoryModel category) async {
    try {
      // Start Loading
      TFullScreenLoader.popUpCircular();

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Map Data

      category.name = name.text.trim();
      category.description = description.text.trim();

      category.updatedAt = DateTime.now();

      // Call Repository to Create New User
      await CategoryRepository.instance.updateCategory(category);

      // Reset Form
      resetFields();

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Success Message & Redirect
      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'Your Record has been updated.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
