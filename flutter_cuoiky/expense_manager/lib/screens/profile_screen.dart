import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_avatar_service.dart';
import '../utils/image_picker_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _avatarUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadAvatarFromFirebase();
  }

  // ======================= LOAD AVATAR TỪ FIREBASE AUTH =======================
  void _loadAvatarFromFirebase() {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.photoURL != null) {
      setState(() => _avatarUrl = user!.photoURL);
    }
  }

  // ======================= UPLOAD AVATAR LÊN IMGBB =======================
  Future<void> _changeAvatar() async {
    try {
      // 1. Chọn ảnh từ Gallery
      final File? file = await PickImage.fromGallery();
      if (file == null) return; // User hủy

      setState(() => _isUploading = true);

      // 2. Upload lên ImgBB
      final imageUrl = await ApiAvatarService.uploadAvatar(file);

      if (imageUrl != null) {
        // 3. Lưu URL vào Firebase Auth
        await FirebaseAuth.instance.currentUser?.updatePhotoURL(imageUrl);
        await FirebaseAuth.instance.currentUser?.reload();

        setState(() {
          _avatarUrl = imageUrl;
          _isUploading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Cập nhật avatar thành công!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('Upload thất bại');
      }
    } catch (e) {
      setState(() => _isUploading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Lỗi: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ======================= LOGOUT =======================
  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Đăng xuất",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Bạn có chắc muốn đăng xuất?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Đăng xuất",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // ⭐ LẤY TÊN (chữ cuối cùng)
    final displayName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : user?.email?.split("@").first ?? "Người dùng";

    final email = user?.email ?? "";

    // ⭐ LẤY CHỮ CÁI ĐẦU CỦA TÊN (không phải họ)
    String initial = "U";
    if (displayName.isNotEmpty) {
      final nameParts = displayName.trim().split(' ');
      if (nameParts.isNotEmpty) {
        initial = nameParts.last[0].toUpperCase();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Hồ sơ",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ======================= AVATAR BOX =======================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.blue.shade100,
                        backgroundImage:
                        _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
                        child: _avatarUrl == null
                            ? Text(
                          initial,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        )
                            : null,
                      ),

                      // Loading overlay khi đang upload
                      if (_isUploading)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),

                      // Nút đổi avatar
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _isUploading ? null : _changeAvatar,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isUploading ? Colors.grey : Colors.teal,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ======================= MENU =======================
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _menuItem(
                    Icons.history,
                    "Lịch sử giao dịch",
                    Colors.black87,
                        () => Navigator.pushNamed(context, "/transactions"),
                  ),

                  const Divider(height: 1, thickness: 0.5),

                  _menuItem(
                    Icons.logout_rounded,
                    "Đăng xuất",
                    Colors.red,
                        () => _logout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
      IconData icon,
      String title,
      Color color,
      VoidCallback onTap,
      ) {
    final isLogout = title == "Đăng xuất";

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isLogout ? Colors.red : Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isLogout ? Colors.red.shade300 : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}