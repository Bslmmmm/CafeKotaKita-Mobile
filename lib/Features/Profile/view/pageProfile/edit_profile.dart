import 'dart:convert';
import 'dart:io';
import 'package:KafeKotaKita/Constant/constants.dart';
import 'package:KafeKotaKita/service/api_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _selectedImage;

  final _storage = GetStorage();
  bool _isChanged = false;
  bool _isLoading = false;

  String? _initialName;
  String? _initialPhone;

  @override
  void initState() {
    super.initState();
    final user = _storage.read(profileKey);
    if (user != null && user is Map) {
      _initialName = user['nama'] ?? '';
      _initialPhone = user['no_telp'] ?? '';
      _usernameController.text = _initialName!;
      _phoneController.text = _initialPhone!;
    }
    _usernameController.addListener(_checkChanged);
    _phoneController.addListener(_checkChanged);
  }

  void _checkChanged() {
    final isNameChanged = _usernameController.text.trim() != (_initialName ?? '');
    final isPhoneChanged = _phoneController.text.trim() != (_initialPhone ?? '');
    final isImageChanged = _selectedImage != null;
    final changed = isNameChanged || isPhoneChanged || isImageChanged;

    if (changed != _isChanged) {
      setState(() {
        _isChanged = changed;
      });
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
      _checkChanged();
    }
  }

  Future<void> _updateProfile() async {
    print("📤 Mulai update profile...");
    final user = _storage.read(profileKey);

    if (user == null || user is! Map) {
      print("❌ User tidak ditemukan di GetStorage");
      return;
    }

    final userId = user['id'].toString();
    final uri = Uri.parse(ApiConfig.updateProfileEndpoint(userId));

    

    final request = http.MultipartRequest('POST', uri);
    request.fields['nama'] = _usernameController.text.trim();
    request.fields['no_telp'] = _phoneController.text.trim();
    print("📦 Data yang dikirim: ${request.fields}");

    if (_selectedImage != null) {
      print("🖼️ Menambahkan foto: ${_selectedImage!.path}");
      request.files.add(await http.MultipartFile.fromPath('foto_profil', _selectedImage!.path));
    } else {
      print("📷 Tidak ada foto dipilih");
    }

    setState(() => _isLoading = true);

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📥 Status code: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _storage.write(profileKey, data['data']); // simpan Map langsung

        setState(() {
          _isChanged = false;
          _selectedImage = null;
          _initialName = data['data']['nama'];
          _initialPhone = data['data']['no_telp'];
        });

        // Tutup halaman EditProfilePage dulu
        Get.back();

        // Tampilkan dialog sukses dengan style konsisten
        await Get.dialog(
          AlertDialog(
            backgroundColor: primaryc,
            title: Text("Sukses", style: AppTextStyles.montserratH1(color: Colors.white)),
            content: Text(
              "Profil berhasil diperbarui",
              style: AppTextStyles.poppinsBody(color: clrfont2),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text("OK", style: AppTextStyles.poppinsBody(color: Colors.white, weight: AppTextStyles.semiBold)),
              ),
            ],
          ),
          barrierDismissible: false,
        );

      } else {
        final error = jsonDecode(response.body);
        Get.snackbar("Gagal", error['message'] ?? "Gagal memperbarui profil");
      }
    } catch (e) {
      print("❌ Error terjadi: $e");
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onSave() {
    print("✔️ Simpan ditekan");
    _updateProfile();
  }

  Future<bool> _onWillPop() async {
    if (_isChanged) {
      final result = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: primaryc,
          title: Text("Konfirmasi", style: AppTextStyles.montserratH1(color: Colors.white)),
          content: Text(
            "Ada perubahan yang belum disimpan. Apakah Anda yakin ingin keluar tanpa menyimpan?",
            style: AppTextStyles.poppinsBody(color: clrfont2),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text("Batal", style: AppTextStyles.poppinsBody(color: Colors.white, weight: AppTextStyles.semiBold)),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text("Keluar", style: AppTextStyles.poppinsBody(color: Colors.white, weight: AppTextStyles.semiBold)),
            ),
          ],
        ),
        barrierDismissible: false,
      );
      return result ?? false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: primaryc,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () async {
                        final canPop = await _onWillPop();
                        if (canPop) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.check, color: _isChanged ? Colors.white : Colors.white54),
                      onPressed: _isChanged && !_isLoading ? _onSave : null,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white24,
                    backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                    child: _selectedImage == null
                        ? const Icon(Icons.person, color: Colors.grey, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Ubah foto profil",
                  style: AppTextStyles.interBody(
                    color: clrfont3,
                    fontSize: 20,
                    weight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildInputField("Username", _usernameController),
                const SizedBox(height: 16),
                _buildInputField("No. Telepon", _phoneController),
                const SizedBox(height: 24),
                if (_isLoading) const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: AppTextStyles.interBody(
        color: Colors.white,
        fontSize: 14,
        weight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: AppTextStyles.interBody(
          color: clrfont2,
          fontSize: 14,
          weight: AppTextStyles.medium,
        ),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: clrfont2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: clrfont2, width: 1.5),
        ),
      ),
    );
  }
}
