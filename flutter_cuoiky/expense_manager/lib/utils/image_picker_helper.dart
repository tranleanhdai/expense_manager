import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PickImage {
  static final ImagePicker _picker = ImagePicker();

  // ================================
  // 📌 Chọn ảnh từ Gallery
  // ================================
  static Future<File?> fromGallery() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85, // giảm dung lượng ảnh -> upload nhanh hơn
      );

      if (picked == null) return null; // user bấm Hủy

      return File(picked.path);
    } catch (e) {
      print("PickImage.fromGallery ERROR: $e");
      return null;
    }
  }

  // ================================
  // 📌 Chụp ảnh từ Camera
  // ================================
  static Future<File?> fromCamera() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (picked == null) return null;

      return File(picked.path);
    } catch (e) {
      print("PickImage.fromCamera ERROR: $e");
      return null;
    }
  }

  // ================================
  // 📌 Chọn video (optional)
  // ================================
  static Future<File?> pickVideo() async {
    try {
      final picked = await _picker.pickVideo(source: ImageSource.gallery);
      if (picked == null) return null;
      return File(picked.path);
    } catch (e) {
      print("PickImage.pickVideo ERROR: $e");
      return null;
    }
  }
}
