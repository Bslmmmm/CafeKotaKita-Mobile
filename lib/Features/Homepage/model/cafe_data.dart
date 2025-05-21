// Features/Homepage/Models/cafe_data.dart

class CafeData {
  final String id;
  final String imageUrl;
  final String cafeName;
  final String location;
  final String operationalHours;
  final double rating;
  final bool isOpen;

  const CafeData({
    required this.id,
    required this.imageUrl,
    required this.cafeName,
    required this.location,
    required this.operationalHours,
    required this.rating,
    required this.isOpen,
  });

  // Create a copy of this CafeData with the given field updated
  CafeData copyWith({
    String? id,
    String? imageUrl,
    String? cafeName,
    String? location,
    String? operationalHours,
    double? rating,
    bool? isOpen,
  }) {
    return CafeData(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      cafeName: cafeName ?? this.cafeName,
      location: location ?? this.location,
      operationalHours: operationalHours ?? this.operationalHours,
      rating: rating ?? this.rating,
      isOpen: isOpen ?? this.isOpen,
    );
  }
}