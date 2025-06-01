
class GenreResponse {
  final String status;
  final String message;
  final GenreData data;

  GenreResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GenreResponse.fromJson(Map<String, dynamic> json) {
    return GenreResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: GenreData.fromJson(json['data'] ?? {}),
    );
  }
}

class GenreData {
  final String id;
  final String nama;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final List<Kafe> kafe;

  GenreData({
    required this.id,
    required this.nama,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.kafe,
  });

  factory GenreData.fromJson(Map<String, dynamic> json) {
    return GenreData(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      kafe: (json['kafe'] as List<dynamic>?)
          ?.map((x) => Kafe.fromJson(x))
          .toList() ?? [],
    );
  }
}

class Kafe {
  final String id;
  final String ownerId;
  final String nama;
  final String alamat;
  final String telp;
  final String latitude;
  final String longitude;
  final String jamBuka;
  final String jamTutup;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final Pivot pivot;
  final List<Gallery> gallery;

  Kafe({
    required this.id,
    required this.ownerId,
    required this.nama,
    required this.alamat,
    required this.telp,
    required this.latitude,
    required this.longitude,
    required this.jamBuka,
    required this.jamTutup,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.pivot,
    required this.gallery,
  });

  factory Kafe.fromJson(Map<String, dynamic> json) {
    return Kafe(
      id: json['id'] ?? '',
      ownerId: json['owner_id'] ?? '',
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      telp: json['telp'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      jamBuka: json['jam_buka'] ?? '',
      jamTutup: json['jam_tutup'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      pivot: Pivot.fromJson(json['pivot'] ?? {}),
      gallery: (json['gallery'] as List<dynamic>?)
          ?.map((x) => Gallery.fromJson(x))
          .toList() ?? [],
    );
  }
}

class Pivot {
  final String genreId;
  final String kafeId;

  Pivot({
    required this.genreId,
    required this.kafeId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      genreId: json['genre_id'] ?? '',
      kafeId: json['kafe_id'] ?? '',
    );
  }
}

class Gallery {
  final String id;
  final String kafeId;
  final String type;
  final String url;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Gallery({
    required this.id,
    required this.kafeId,
    required this.type,
    required this.url,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      id: json['id'] ?? '',
      kafeId: json['kafe_id'] ?? '',
      type: json['type'] ?? '',
      url: json['url'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}