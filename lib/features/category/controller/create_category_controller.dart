import 'package:dashboard/data/repositories/categories/category_repository.dart';
import 'package:dashboard/features/category/controller/category_controller.dart';
import 'package:dashboard/features/category/models/category_model.dart';
import 'package:dashboard/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/loaders.dart';

class CreateCategoryController extends GetxController {
  static CreateCategoryController get instance => Get.find();

  final selectedParent = CategoryModel.empty().obs;
  final loading = false.obs;

  final name = TextEditingController();
  final description = TextEditingController();
  final formKey = GlobalKey<FormState>();

  /// Method to reset fields
  void resetFields() {
    selectedParent(CategoryModel.empty());
    loading(false);

    name.clear();
    description.clear();
  }

  /// Pick Thumbnail Image from Media
  // void pickImage() async {
  //   final controller = Get.put(MediaController());
  //   List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

  //   // Handle the selected images
  //   if (selectedImages != null && selectedImages.isNotEmpty) {
  //     // Set the selected image to the main image or perform any other action
  //     ImageModel selectedImage = selectedImages.first;
  //     // Update the main image using the selectedImage
  //     imageURL.value = selectedImage.url;
  //   }
  // }

  /// Register new Category
  Future<void> createCategory() async {
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
      final newRecord = CategoryModel(
        id: '',
        name: name.text.trim(),
        description: description.text.trim(),
        createdAt: DateTime.now(),
      );

      // // Call Repository to Create New Category
      newRecord.id =
          await CategoryRepository.instance.createCategory(newRecord);

      // Update All Data list
      CategoryController.instance.addItemToLists(newRecord);

      // Reset Form
      resetFields();

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Success Message & Redirect
      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'New Record has been added.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
