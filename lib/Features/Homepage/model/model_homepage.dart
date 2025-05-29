import 'package:KafeKotaKita/service/api_config.dart';

class CafeData {
  final String id;
  final String imageUrl;
  final String cafename;
  final String alamat;
  final String jambuka;
  final String jamtutup;
  final double rating;
  final bool isOpen;

  const CafeData({
    required this.id,
    required this.imageUrl,
    required this.cafename,
    required this.alamat,
    required this.jambuka,
    required this.jamtutup,
    required this.rating,
    required this.isOpen,
  });

  CafeData copyWith({
    String? id,
    String? imageUrl,
    String? cafeName,
    String? location,
    String? jambuka,
    String? jamtutup,
    double? rating,
    bool? isOpen,
  }) {
    return CafeData(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      cafename: cafeName ?? cafename,
      alamat: location ?? alamat,
      jambuka: jambuka ?? this.jambuka,
      jamtutup: jamtutup ?? this.jamtutup,
      rating: rating ?? this.rating,
      isOpen: isOpen ?? this.isOpen,
    );
  }

  factory CafeData.fromJson(Map<String, dynamic> json) {
    // ubah format jam 
    String formatTime(String timeStr) {
      final parts = timeStr.split(":");
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }

    String getMainImageUrl(List<dynamic> galleryList) {
      final mainImage = galleryList.firstWhere(
        (item) => item['type'] == 'main_content',
        orElse: () => null,
      );

      if (mainImage != null && mainImage['url'] != null) {
        return '${ApiConfig.baseUrl}/storage/${mainImage['url']}';
      }

      return 'https://via.placeholder.com/150';
    }

    return CafeData(
      id: json['id'],
      imageUrl: getMainImageUrl(json['gallery']),
      cafename: json['nama'],
      alamat: json['alamat'],
      jambuka: formatTime(json['jam_buka']),
      jamtutup: formatTime(json['jam_tutup']),
      rating: json['total_rating'] == null
          ? 0.0
          : double.tryParse(json['total_rating'].toString()) ?? 0.0,
      isOpen: false, // akan diupdate oleh CafeStatusUpdater
    );
  }
}
