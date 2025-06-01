import 'dart:convert';
import 'dart:io';
import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';
import 'package:KafeKotaKita/Features/DetailCafe/models/model_detailC.dart';
import 'package:KafeKotaKita/service/api_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:KafeKotaKita/Constant/constants.dart';


class CafeDetailController extends GetxController {
  // Observable variables
  var isSaved = false.obs;
  var userRating = 0.obs;
  var isTogglingBookmark = false.obs;
  var isLoading = true.obs;
  var hasRated = false.obs;

  
  Rx<CafeDetailModel?> cafeData = Rx<CafeDetailModel?>(null);
  
  late String cafeId;
  late String userId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is String) {
      cafeId = Get.arguments as String;
      print('Cafe Id diterima: $cafeId');
    }else{
      print('CafeId tidak ditemukan ');
    }
    initializeUser();
  }

  void initializeUser() {
    final user = GetStorage().read(profileKey);
    if (user == null || user['id'] == null) {
      Get.snackbar('Error', 'User tidak ditemukan');
      return;
    }

    userId = user['id'];
    fetchCafeDetail();
  }

  Future<void> fetchCafeDetail() async {
    try {
      isLoading.value = true;
      final url = Uri.parse('${ApiConfig.kafeDetail}$cafeId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        cafeData.value = CafeDetailModel.fromJson(json['data']);
        isLoading.value = false;
        
        // Setelah data berhasil dimuat, cek status bookmark
        await checkBookmarkStatus();
        await checkUserRating();
      } else {
        print("Gagal mengambil data: ${response.body}");
        isLoading.value = false;
      }
    } catch (e) {
      print("Error: $e");
      isLoading.value = false;
    }
  }

  Future<void> checkBookmarkStatus() async {
    try {
      final request = BookmarkRequest(userId: userId, kafeId: cafeId);
      final response = await http.post(
        Uri.parse(ApiConfig.checkBookmark),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        isSaved.value = json['is_bookmarked'] ?? false;
      } else {
        print('Gagal memeriksa status bookmark: ${response.body}');
      }
    } catch (e) {
      print('Error saat cek bookmark: $e');
    }
  }

  Future<void> addBookmark() async {
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final request = BookmarkRequest(userId: userId, kafeId: cafeId);

    try {
      isTogglingBookmark.value = true;
      final response = await http.post(
        Uri.parse(ApiConfig.addBookmark),
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        isSaved.value = true;
      } else {
        Get.snackbar("Gagal", json['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menambahkan bookmark");
    } finally {
      isTogglingBookmark.value = false;
    }
  }

  Future<void> removeBookmark() async {
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final request = BookmarkRequest(userId: userId, kafeId: cafeId);

    try {
      isTogglingBookmark.value = true;
      final httpRequest = http.Request('DELETE', Uri.parse(ApiConfig.removeBookmark));
      httpRequest.headers.addAll(headers);
      httpRequest.body = jsonEncode(request.toJson());
      
      final streamedResponse = await httpRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        isSaved.value = false;
      } else {
        Get.snackbar("Gagal", json['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus bookmark");
    } finally {
      isTogglingBookmark.value = false;
    }
  }

  Future<void> toggleBookmark() async {
    if (isSaved.value) {
      await removeBookmark();
    } else {
      await addBookmark();
    }
  }

  Future<void> submitRating() async {
    final url = Uri.parse(ApiConfig.addRating);
    final request = RatingRequest(
      userId: userId,
      kafeId: cafeId,
      rate: userRating.value,
    );

    try {
      final response = await http.post(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 201) {
  hasRated.value = true; // Tambahkan ini
  _showCustomDialog(
    title: 'Sukses!',
    message: 'Rating berhasil dikirim!',
    onOkPressed: () {
      fetchCafeDetail(); // Refresh data
    },
  );
}
 else if (response.statusCode == 409) {
  hasRated.value = true; // Tambahkan ini juga
  _showCustomDialog(
    title: 'Sudah Pernah!',
    message: 'Kamu sudah pernah memberi rating pada kafe ini.',
    onOkPressed: () {},
  );
}
 else {
        _showCustomDialog(
          title: 'Gagal!',
          message: json['message'] ?? 'Terjadi kesalahan saat mengirim rating.',
          onOkPressed: () {},
        );
      }
    } catch (e) {
      _showCustomDialog(
        title: 'Error!',
        message: 'Terjadi kesalahan: $e',
        onOkPressed: () {},
      );
    }
  }

  Future<void> checkUserRating() async {
  try {
    final response = await http.post(
      Uri.parse(ApiConfig.checkUserRating),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'kafe_id': cafeId,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      hasRated.value = json['rated'] ?? false;
      if (hasRated.value) {
        userRating.value = json['rate_value'] ?? 0;
      }
    } else {
      print("Gagal memeriksa rating user: ${response.body}");
    }
  } catch (e) {
    print("Error saat cek rating: $e");
  }
}


  void setUserRating(int rating) {
    userRating.value = rating;
  }

  List<GalleryModel> getMainGallery() {
    if (cafeData.value?.gallery == null) return [];
    return cafeData.value!.gallery!
        .where((item) => item.type == 'main_content')
        .toList();
  }

  List<GalleryModel> getMenuGallery() {
    if (cafeData.value?.gallery == null) return [];
    return cafeData.value!.gallery!
        .where((item) => item.type == 'menu_content')
        .toList();
  }

  IconData getFacilityIcon(String name) {
    name = name.toLowerCase();

    if (name.contains('toilet')) return Icons.wc;
    if (name.contains('parkir')) return Icons.local_parking;
    if (name.contains('kerja')) return Icons.chair;
    if (name.contains('merokok')) return Icons.smoking_rooms;
    if (name.contains('outdoor')) return Icons.deck;
    if (name.contains('live music') || name.contains('musik'))
      return Icons.music_note;
    if (name.contains('stop kontak')) return Icons.power;
    if (name.contains('ac')) return Icons.ac_unit;
    if (name.contains('musala') || name.contains('mushola'))
      return Icons.mosque;
    if (name.contains('wifi') || name.contains('wi-fi')) return Icons.wifi;
    if (name.contains('boardgame')) return Icons.extension;
    if (name.contains('cashless')) return Icons.credit_card;
    if (name.contains('cash')) return Icons.attach_money;
    if (name.contains('meeting') || name.contains('ruang meeting'))
      return Icons.meeting_room;

    return Icons.check_circle_outline;
  }

  void _showCustomDialog({
  required String title,
  required String message,
  required VoidCallback onOkPressed,
}) {
  Get.dialog(
    AlertDialog(
      backgroundColor: primaryc,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: AppTextStyles.montserratH1(color: white),
      ),
      content: Text(
        message,
        style: AppTextStyles.poppinsBody(color: white),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            onOkPressed();
          },
          child: Text(
            "OK",
            style: AppTextStyles.poppinsBody(
              color: white,
              weight: AppTextStyles.semiBold,
            ),
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

}