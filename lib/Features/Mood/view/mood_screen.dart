import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';
import 'package:KafeKotaKita/Features/Mood/services/genre_services.dart';
import 'package:KafeKotaKita/components/widget/custom_btnback.dart';
import 'package:KafeKotaKita/components/widget/custom_card_cafe.dart';
import 'package:KafeKotaKita/Features/Mood/models/genre_model.dart';
import 'package:KafeKotaKita/service/api_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  bool isLoading = false;
  GenreResponse? genreResponse;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final carouselType = arguments?['carouselType'] ?? 'default';
    
    String? genreId = _getGenreIdFromCarouselType(carouselType);
    
    if (genreId != null) {
      await _fetchGenreData(genreId);
    } else {
      // Handle case dimana carouselType tidak dikenali
      setState(() {
        errorMessage = 'Tipe mood tidak dikenali: $carouselType';
        isLoading = false;
      });
    }
  }

  String? _getGenreIdFromCarouselType(String carouselType) {
    final String tradisional = '179e7bfa-b364-4ad1-937b-fb5e68efa2d9';
    final String viewbagus = 'bf56109c-d1c2-4dee-b18a-d563843f939c';
    final String retro = 'bf422e41-d1f0-442f-b09a-c90401765d48';
    
    switch (carouselType) {
      case 'mood1':
        return tradisional; 
      case 'mood2':
        return viewbagus; 
      case 'mood3':
        return retro;
      default:
        return null;
    }
  }

  Future<void> _fetchGenreData(String genreId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await GenreService.getGenreById(genreId);
      setState(() {
        genreResponse = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  bool _isCafeOpen(String jamBuka, String jamTutup) {
    try {
      final now = TimeOfDay.now();
      final currentMinutes = now.hour * 60 + now.minute;
      
      final bukaParts = jamBuka.split(':');
      final tutupParts = jamTutup.split(':');
      
      final bukaMinutes = int.parse(bukaParts[0]) * 60 + int.parse(bukaParts[1]);
      final tutupMinutes = int.parse(tutupParts[0]) * 60 + int.parse(tutupParts[1]);
      
      if (tutupMinutes < bukaMinutes) {
        // Cafe buka melewati tengah malam
        return currentMinutes >= bukaMinutes || currentMinutes <= tutupMinutes;
      } else {
        return currentMinutes >= bukaMinutes && currentMinutes <= tutupMinutes;
      }
    } catch (e) {
      return true; // Default buka jika ada error parsing
    }
  }

  // Helper function untuk mendapatkan URL gambar lengkap  
  String _getImageUrl(Kafe kafe) {
    if (kafe.gallery.isNotEmpty) {
      final mainImage = kafe.gallery.firstWhere(
        (gallery) => gallery.type == 'main_content',
        orElse: () => kafe.gallery.first,
      );
      return '${ApiConfig.baseUrl}/storage/${mainImage.url}';
    }
    return 'assets/kosong/fallback.png'; 
  }

  // Helper function untuk format waktu
  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
      return time;
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final title = arguments?['title'] ?? 'Mood';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyles.poppinsBody(
              fontSize: 25, weight: AppTextStyles.bold, color: primaryc),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomBackButton(
            onPressed: () {
              Get.back();
            },
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(color: primaryc),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: AppTextStyles.poppinsBody(
                fontSize: 18,
                weight: AppTextStyles.semiBold,
                color: Colors.grey[600]!,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              style: AppTextStyles.poppinsBody(
                fontSize: 14,
                weight: AppTextStyles.regular,
                color: Colors.grey[500]!,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryc,
                foregroundColor: Colors.white,
              ),
              child: Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (genreResponse == null || genreResponse!.data.kafe.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_cafe,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada cafe yang tersedia',
              style: AppTextStyles.poppinsBody(
                fontSize: 16,
                weight: AppTextStyles.regular,
                color: Colors.grey[600]!,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: primaryc,
      child: ListView(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  genreResponse!.data.nama,
                  style: AppTextStyles.poppinsBody(
                    fontSize: 24,
                    weight: AppTextStyles.bold,
                    color: primaryc,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${genreResponse!.data.kafe.length} cafe tersedia',
                  style: AppTextStyles.poppinsBody(
                    fontSize: 14,
                    weight: AppTextStyles.regular,
                    color: Colors.grey[600]!,
                  ),
                ),
              ],
            ),
          ),

          // Cafe List menggunakan CustomCardCafe yang sudah ada
          ...genreResponse!.data.kafe.map(
            (kafe) => CustomCardCafe(
              cafeimgurl: _getImageUrl(kafe),
              namacafe: kafe.nama,
              lokasi: kafe.alamat,
              jambuka: _formatTime(kafe.jamBuka),
              jamtutup: _formatTime(kafe.jamTutup),
              rating: 4.5, // Default rating, sesuaikan jika ada field rating di API
              isOpen: _isCafeOpen(kafe.jamBuka, kafe.jamTutup),
              onTap: () {
                // Navigate to cafe detail
                Get.toNamed('/cafe-detail', arguments: {
                  'cafeId': kafe.id,
                  'cafe': kafe,
                });
              },
            ),
          ).toList(),

          // Bottom spacing
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}