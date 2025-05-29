import 'package:KafeKotaKita/Constant/constants.dart';
import 'package:KafeKotaKita/Features/SavedCafe/model/model_saved_cafe.dart';
import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../components/widget/custom_btnback.dart';
import '../../../components/widget/custom_card_cafe.dart';
import 'package:KafeKotaKita/service/api_config.dart';

class SavedCafeScreen extends StatefulWidget {
  const SavedCafeScreen({super.key});

  @override
  State<SavedCafeScreen> createState() => _SavedCafeScreenState();
}

class _SavedCafeScreenState extends State<SavedCafeScreen> {
  List<SavedCafeItem> _savedCafes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCafes();
  }

  Future<void> _loadSavedCafes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profileRaw = GetStorage().read(profileKey);
      print('Raw profile: $profileRaw');

      Map<String, dynamic> profile;

      if (profileRaw is String) {
        profile = jsonDecode(profileRaw); // decode dari string JSON ke Map
      } else if (profileRaw is Map<String, dynamic>) {
        profile = profileRaw;
      } else {
        throw Exception('Data profile dari storage tidak valid');
      }

      final userId = profile['id'];
      print('User ID: $userId');

      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/findBookmarkByUser/$userId'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'];

        final savedCafes =
            data.map((item) => SavedCafeItem.fromJson(item)).toList();

        setState(() {
          _savedCafes = savedCafes;
        });
      } else {
        // Tangani error response
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat load saved cafes: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrbg,
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 16),
            color: clrbg,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: const CustomBackButton(),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: primaryc,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Saved Cafe',
                        style: AppTextStyles.montserratBody(
                          color: white,
                          fontSize: 20,
                          weight: AppTextStyles.semiBold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _savedCafes.isNotEmpty
                    ? RefreshIndicator(
                        onRefresh: _loadSavedCafes,
                        color: primaryc,
                        child: ListView.builder(
                            padding: const EdgeInsets.only(top: 8, bottom: 16),
                            itemCount: _savedCafes.length,
                            itemBuilder: (context, index) {
                              final cafe = _savedCafes[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: CustomCardCafe(
                                  cafeimgurl: cafe.imageUrl,
                                  namacafe: cafe.cafename,
                                  lokasi: cafe.alamat,
                                  jambuka: cafe.jambuka,
                                  jamtutup: cafe.jamtutup,
                                  rating: cafe.rating,
                                  isOpen: cafe.isOpen,
                                  onTap: () {
                                    print('Cafe tapped: ${cafe.cafename}');
                                    // Navigasi ke detail kalau diperlukan
                                  },
                                ),
                              );
                            }),
                      )
                    : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  // Widget untuk state kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: primaryc.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.bookmark_outline,
              color: primaryc,
              size: 50,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Cafe Tersimpan',
            style: AppTextStyles.poppinsBody(
              color: primaryc,
              fontSize: 18,
              weight: AppTextStyles.semiBold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan cafe favorit kamu\nagar mudah ditemukan kembali',
            textAlign: TextAlign.center,
            style: AppTextStyles.interBody(
              color: primaryc.withOpacity(0.7),
              fontSize: 14,
              weight: AppTextStyles.regular,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Kembali ke halaman sebelumnya
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryc,
              foregroundColor: white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Cari Cafe',
              style: AppTextStyles.interBody(
                color: white,
                fontSize: 14,
                weight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
