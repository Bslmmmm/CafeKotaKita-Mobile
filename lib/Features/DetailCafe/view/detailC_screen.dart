import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';
import 'package:KafeKotaKita/components/widget/custom_btnback.dart';
import 'package:KafeKotaKita/Constant/constants.dart';

class DetailcScreen extends StatefulWidget {
  const DetailcScreen({super.key});

  @override
  State<DetailcScreen> createState() => _DetailcScreenState();
}

class _DetailcScreenState extends State<DetailcScreen> {
  bool isSaved = false;
  int userRating = 0;

  Map<String, dynamic>? cafeData;
  bool isLoading = true;

  final String cafeId = '9f0a8d36-a2b9-42f1-b630-abc151d199ed';
  late String userId;

  @override
  void initState() {
    super.initState();
    final user = GetStorage().read(profileKey);
    userId = user['id'];
    fetchCafeDetail();
    checkBookmarkStatus();
  }

  Future<void> fetchCafeDetail() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.5:8000/api/kafe/detail/$cafeId'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          cafeData = json['data'];
          isLoading = false;
        });
      } else {
        print("Gagal mengambil data: ${response.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> checkBookmarkStatus() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.5:8000/api/bookmark/findBookmarkByUser?user_id=$userId'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          isSaved = json['is_bookmarked'] == true;
        });
      }
    } catch (e) {
      print("Error checking bookmark: $e");
    }
  }

  Future<void> toggleBookmark() async {
    final url = isSaved
        ? Uri.parse('http://192.168.1.5:8000/api/bookmark/removeBookmark')
        : Uri.parse('http://192.168.1.5:8000/api/bookmark/addBookmark');

    try {
      final response = isSaved
          ? await http.delete(url, body: {
              'user_id': userId,
              'kafe_id': cafeId,
            })
          : await http.post(url, body: {
              'user_id': userId,
              'kafe_id': cafeId,
            });

      final json = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        setState(() {
          isSaved = !isSaved;
        });
      } else {
        print("Gagal: ${json['message']}");
      }
    } catch (e) {
      print("Error saat bookmark: $e");
    }
  }

  Future<void> submitRating() async {
    final url = Uri.parse('http://192.168.1.5:8000/api/rating/addRate');
    try {
      final response = await http.post(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'kafe_id': cafeId,
          'rate': userRating,
        }),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 201) {
        showCustomDialog(
          title: 'Sukses!',
          message: 'Rating berhasil dikirim!',
          onOkPressed: () {
            fetchCafeDetail(); // refresh data rating kafe
          },
        );
      } else if (response.statusCode == 409) {
        showCustomDialog(
          title: 'Sudah Pernah!',
          message: 'Kamu sudah pernah memberi rating pada kafe ini.',
          onOkPressed: () {},
        );
      } else {
        showCustomDialog(
          title: 'Gagal!',
          message: json['message'] ?? 'Terjadi kesalahan saat mengirim rating.',
          onOkPressed: () {},
        );
      }
    } catch (e) {
      showCustomDialog(
        title: 'Error!',
        message: 'Terjadi kesalahan: $e',
        onOkPressed: () {},
      );
    }
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

    return Icons.check_circle_outline;
  }

  Widget facilitiesSection() {
    List<dynamic> facilities = cafeData?['fasilitas'] ?? [];

    if (facilities.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fasilitas', style: AppTextStyles.h3(color: white)),
        SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: facilities.map<Widget>((facility) {
            final String name = facility['nama'] ?? '-';
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: clrfont3.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(getFacilityIcon(name), color: white, size: 20),
                  SizedBox(width: 8),
                  Text(name, style: AppTextStyles.bodyMedium(color: white)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget genreSection() {
    List<dynamic> genres = cafeData?['genre'] ?? [];

    if (genres.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Genre', style: AppTextStyles.h3(color: white)),
        SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: genres.map<Widget>((genre) {
            final String name = genre['nama'] ?? '-';
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: clrfont3.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(name, style: AppTextStyles.bodyMedium(color: white)),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || cafeData == null) {
      return Scaffold(
        backgroundColor: black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final galleryList = cafeData?['gallery'] ?? [];
    final firstImagePath =
        galleryList.isNotEmpty ? galleryList[0]['url'] : null;
    final firstImageUrl = firstImagePath != null
        ? 'http://192.168.1.5:8000/storage/$firstImagePath'
        : null;

    return Scaffold(
      backgroundColor: black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: firstImageUrl != null
                          ? NetworkImage(firstImageUrl)
                          : AssetImage('assets/images/gallery.jpg')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: CustomBackButton(),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cafeData?['nama'] ?? '-',
                                style: AppTextStyles.h1(color: white)),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.orange, size: 20),
                                SizedBox(width: 4),
                                Text(
                                  (cafeData?['total_rating']
                                          ?.toStringAsFixed(1) ??
                                      '0.0'),
                                  style: AppTextStyles.bodyMedium(
                                      color: white,
                                      weight: AppTextStyles.semiBold),
                                ),
                                SizedBox(width: 4),
                                Text('(rating)',
                                    style: AppTextStyles.bodyMedium(
                                        color: clrfont2)),
                              ],
                            ),
                            SizedBox(height: 8),

                            // Hapus Cafe Modern, langsung tampilkan genre
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: (cafeData?['genre'] ?? [])
                                  .map<Widget>((genre) {
                                final name = genre['nama'] ?? '-';
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: clrfont3.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(name,
                                      style: AppTextStyles.bodySmall(
                                          color: white)),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: toggleBookmark,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: clrfont3.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? Colors.orange : white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  infoBox(Icons.location_on, cafeData?['alamat'] ?? '-'),
                  SizedBox(height: 16),

                  infoBox(Icons.access_time,
                      'Buka: ${cafeData?['jam_buka'] ?? '-'} - ${cafeData?['jam_tutup'] ?? '-'}'),
                  SizedBox(height: 16),

                 GestureDetector(
  onTap: () {
    final List<dynamic>? galleryList = cafeData?['gallery'];
    final List<dynamic> menuGalleryList = galleryList != null
        ? galleryList.where((item) => item['type'] == 'menu_content').toList()
        : [];

    if (menuGalleryList.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: menuGalleryList.map<Widget>((menuItem) {
                    final imageUrl =
                        'http://192.168.1.5:8000/storage/${menuItem['url']}';
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Image.network(
                        imageUrl,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          color: Colors.grey,
                          width: 200,
                          height: 200,
                          child: Center(child: Icon(Icons.error)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      );
    } else {
      Get.snackbar('Info', 'Menu belum tersedia');
    }
  },
  child: infoBox(Icons.restaurant_menu, 'Menu', showArrow: true),
),


SizedBox(height: 24),

                  // Fasilitas sekarang ditampilkan di sini
                  facilitiesSection(),
                  SizedBox(height: 24),
                  

                  ratingSection(),
                  SizedBox(height: 24),

                  giveRatingSection(),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoBox(IconData icon, String text, {bool showArrow = false}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration:
          BoxDecoration(color: white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: black, size: 20),
          SizedBox(width: 12),
          Expanded(
              child: Text(text, style: AppTextStyles.bodyMedium(color: black))),
          if (showArrow)
            Icon(Icons.keyboard_arrow_right, color: black, size: 20),
        ],
      ),
    );
  }

  Widget ratingSection() {
    return Row(
      children: [
        Text((cafeData?['total_rating']?.toStringAsFixed(1) ?? '0.0'),
            style: AppTextStyles.h1(color: white)),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: List.generate(5,
                    (_) => Icon(Icons.star, color: Colors.orange, size: 16))),
            SizedBox(height: 4),
            Text('(rating)', style: AppTextStyles.bodySmall(color: clrfont2)),
          ],
        ),
      ],
    );
  }

  Widget giveRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Beri Rating', style: AppTextStyles.h3(color: white)),
        SizedBox(height: 16),
        Row(
          children: [
            SizedBox(width: 12),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => setState(() => userRating = index + 1),
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      userRating > index ? Icons.star : Icons.star_border,
                      color: userRating > index ? Colors.orange : clrfont2,
                      size: 24,
                    ),
                  ),
                );
              }),
            ),
            if (userRating > 0) ...[
              SizedBox(width: 12),
              Text('($userRating/5)',
                  style: AppTextStyles.bodyMedium(color: clrfont2)),
            ]
          ],
        ),
        SizedBox(height: 16),
        if (userRating > 0)
          ElevatedButton(
            onPressed: submitRating,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text("Kirim Rating", style: TextStyle(color: Colors.white)),
          )
      ],
    );
  }

  void showCustomDialog({
    required String title,
    required String message,
    required VoidCallback onOkPressed,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: primaryc,
        title: Text(title, style: AppTextStyles.montserratH1(color: white)),
        content:
            Text(message, style: AppTextStyles.poppinsBody(color: clrfont2)),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              onOkPressed();
            },
            child: Text("OK",
                style: AppTextStyles.poppinsBody(
                    color: white, weight: AppTextStyles.semiBold)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
