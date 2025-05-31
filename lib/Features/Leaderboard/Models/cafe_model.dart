class CafeModel {
  final int id;
  final String name;
  final String address;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int weeklyRank;
  final DateTime createdAt;
  final DateTime updatedAt;

  CafeModel({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.weeklyRank,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CafeModel.fromJson(Map<String, dynamic> json) {
    return CafeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      imageUrl: json['image_url'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      weeklyRank: json['weekly_rank'] ?? 0,
      createdAt:
          DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt:
          DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'image_url': imageUrl,
      'rating': rating,
      'review_count': reviewCount,
      'weekly_rank': weeklyRank,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'CafeModel(id: $id, name: $name, rating: $rating, reviewCount: $reviewCount, weeklyRank: $weeklyRank)';
  }
}
