import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service class for Supabase Storage operations
class TSupabaseStorageService extends GetxController {
  static TSupabaseStorageService get instance => Get.find();

  final SupabaseClient _supabaseClient = Supabase.instance.client;

  /// Uploads image data from assets to Supabase Storage
  /// Returns a Uint8List containing image data.
  Future<Uint8List> getImageDataFromAssets(String path) async {
    try {
      final byteData = await rootBundle.load(path);
      final imageData = byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      return imageData;
    } catch (e) {
      // Handle exceptions gracefully
      throw 'Error loading image data: $e';
    }
  }

  /// Uploads image data to Supabase Storage
  /// Returns the public URL of the uploaded image.
  Future<String> uploadImageData(
      String bucket, Uint8List image, String name) async {
    try {
      final response =
          await _supabaseClient.storage.from(bucket).uploadBinary(name, image);

      if (response != null) {
        throw 'Error uploading image: ';
      }

      // Generate public URL for the uploaded file
      final publicUrl = _supabaseClient.storage.from(bucket).getPublicUrl(name);
      return publicUrl;
    } catch (e) {
      // Handle exceptions gracefully
      throw 'Something went wrong! Error: $e';
    }
  }

  /// Uploads image file to Supabase Storage
  /// Returns the public URL of the uploaded image.
  Future<String> uploadImageFile(String bucket, XFile image) async {
    try {
      final file = await image.readAsBytes();
      final response = await _supabaseClient.storage
          .from(bucket)
          .uploadBinary(image.name, file);
      // Generate public URL for the uploaded file
      final publicUrl =
          _supabaseClient.storage.from(bucket).getPublicUrl(image.name);
      print('Public URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      // Handle exceptions gracefully
      throw 'Something went wrong! Error: $e';
    }
  }
}
