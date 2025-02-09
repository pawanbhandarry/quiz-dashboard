import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/repositories/admin/admin_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../data/services/cloud_storage/supabase_storage_service.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

import '../models/admin_model.dart';

/// Controller for managing admin-related data and operations
class AdminController extends GetxController {
  static AdminController get instance => Get.find();

  // Observable variables
  RxBool loading = false.obs;
  Rx<AdminModel> user = AdminModel.empty().obs;

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  // Dependencies
  final userRepository = Get.put(AdminRepository());
  final storageService = Get.put(TSupabaseStorageService());

  @override
  void onInit() {
    // Fetch user details on controller initialization
    fetchUserDetails();
    super.onInit();
  }

  /// Fetches user details from the repository
  Future<AdminModel> fetchUserDetails() async {
    try {
      loading.value = true;
      if (user.value.id == null || user.value.id!.isEmpty) {
        final user = await userRepository.fetchAdminDetails();
        this.user.value = user;
      }

      firstNameController.text = user.value.firstName;
      lastNameController.text = user.value.lastName;

      loading.value = false;
      return user.value;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Something went wrong.', message: e.toString());
      return AdminModel.empty();
    }
  }

  Future<void> updateProfilePicture() async {
    try {
      loading.value = true;
      // Pick image
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Upload image to Supabase storage
        final uploadedUrl =
            await storageService.uploadImageFile('admin_profiles', pickedFile);
        print(uploadedUrl);

        // Update user profile in Supabase
        await userRepository
            .updateSingleField({'profile_picture': uploadedUrl});

        // Refresh user data
        user.value.profilePicture = uploadedUrl;
        user.refresh();
        TLoaders.successSnackBar(
            title: 'Congratulations',
            message: 'Your Profile Picture has been updated.');
      }
      loading.value = false;
    } catch (e) {
      print(e);
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  /// Pick Thumbnail Image from Media
  // void updateProfilePicture() async {
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
  //       await userRepository
  //           .updateSingleField({'ProfilePicture': selectedImage.url});

  //       // Update the main image using the selectedImage
  //       user.value.profilePicture = selectedImage.url;
  //       user.refresh();
  //       TLoaders.successSnackBar(
  //           title: 'Congratulations',
  //           message: 'Your Profile Picture has been updated.');
  //     }
  //     loading.value = false;
  //   } catch (e) {
  //     loading.value = false;
  //     TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
  //   }
  // }

  void updateUserInformation() async {
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
      user.value.firstName = firstNameController.text.trim();
      user.value.lastName = lastNameController.text.trim();

      await userRepository.updateUserDetails(user.value);
      user.refresh();

      loading.value = false;
      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'Your Profile has been updated.');
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
