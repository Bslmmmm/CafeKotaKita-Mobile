//ini class model_saved_cafe.dart
import 'package:KafeKotaKita/service/api_config.dart';

class SavedCafeItem {
  final String id;
  final String imageUrl;
  final String cafename;
  final String alamat;
  final String jambuka;
  final String jamtutup;
  final double rating;
  final bool isOpen;

  SavedCafeItem({
    required this.id,
    required this.imageUrl,
    required this.cafename,
    required this.alamat,
    required this.jambuka,
    required this.jamtutup,
    required this.rating,
    required this.isOpen,
  });

  factory SavedCafeItem.fromJson(Map<String, dynamic> json) {
    if (json['kafe'] is! Map<String, dynamic>) {
    throw Exception('Expected json["kafe"] to be Map, got: ${json['kafe'].runtimeType}');
  }
    final kafe = json['kafe'];
    final gallery = kafe['gallery'] as List<dynamic>? ?? [];

    // <=============== Format waktu ==================>
    String formatTime(String timeStr) {
      final parts = timeStr.split(":");
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }

    String getMainImageUrl(List<dynamic> galleryList) {
      if (galleryList.isEmpty) return 'assets/kosong/fallback.png';

      final mainImage = galleryList.firstWhere(
        (item) => item['type'] == 'main_content',
        orElse: () => {},
      );

      if (mainImage.isNotEmpty && mainImage['url'] != null) {
        return '${ApiConfig.baseUrl}/storage/${mainImage['url']}';
      }

      return 'assets/kosong/fallback.png';
    }

    return SavedCafeItem(
      id: kafe['id'],
      imageUrl: getMainImageUrl(gallery),
      cafename: kafe['nama'],
      alamat: kafe['alamat'],
      jambuka: formatTime(kafe['jam_buka']),
      jamtutup: formatTime(kafe['jam_tutup']),
      rating: kafe['total_rating'] == null
          ? 0.0
          : double.tryParse(kafe['total_rating'].toString()) ?? 0.0,
      isOpen: false, 
    );
  }
}
