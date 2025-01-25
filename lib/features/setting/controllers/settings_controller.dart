import 'package:dashboard/data/repositories/settings/setting_repository.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

// Observable variables
  RxBool loading = false.obs;

  final formKey = GlobalKey<FormState>();
  final appNameController = TextEditingController();
  final taxController = TextEditingController();
  final shippingController = TextEditingController();
  final freeShippingThresholdController = TextEditingController();

  // Dependencies

  @override
  void onInit() {
    // Fetch setting details on controller initialization

    super.onInit();
  }

  /// Pick Thumbnail Image from Media
  // void updateAppLogo() async {
  //   try {
  //     loading.value = true;
  //     final controller = Get.put(MediaController());
  //     List<ImageModel>? selectedImages =
  //         await controller.selectImagesFromMedia();

  //     // Handle the selected images
  //     if (selectedImages != null && selectedImages.isNotEmpty) {
  //       // Set the selected image to the main image or perform any other action
  //       ImageModel selectedImage = selectedImages.first;

  //       // Update Profile in Firestore
  //       await settingRepository
  //           .updateSingleField({'appLogo': selectedImage.url});

  //       // Update the main image using the selectedImage
  //       settings.value.appLogo = selectedImage.url;
  //       settings.refresh();

  //       TLoaders.successSnackBar(
  //           title: 'Congratulations', message: 'App Logo has been updated.');
  //     }
  //     loading.value = false;
  //   } catch (e) {
  //     loading.value = false;
  //     TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
  //   }
  // }

  void updateSettingInformation() async {
    try {
      loading.value = true;

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

      loading.value = false;
      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'App Settings has been updated.');
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
