import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiAvatarService {
  // ⭐ ImgBB API
  static const String _apiKey = '8e15965f5b3cdeb113070998370518e7';
  static const String _uploadUrl = 'https://api.imgbb.com/1/upload';

  // ========================= UPLOAD ẢNH LÊN IMGBB =========================
  static Future<String?> uploadAvatar(File imageFile) async {
    try {
      print('📤 Đang upload ảnh lên ImgBB...');

      // Đọc file thành bytes
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Gửi request tới ImgBB
      final response = await http.post(
        Uri.parse(_uploadUrl),
        body: {
          'key': _apiKey,
          'image': base64Image,
        },
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Lấy URL ảnh từ response
        if (data['success'] == true) {
          final imageUrl = data['data']['url'] as String;
          print('✅ Upload thành công: $imageUrl');
          return imageUrl;
        }
      }

      print('❌ ImgBB upload error: ${response.body}');
      return null;
    } catch (e) {
      print('❌ Upload avatar error: $e');
      return null;
    }
  }
}