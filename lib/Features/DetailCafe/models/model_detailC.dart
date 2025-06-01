class CafeDetailModel {
  String? id;
  String? nama;
  String? alamat;
  String? jamBuka;
  String? jamTutup;
  double? totalRating;
  List<FasilitasModel>? fasilitas;
  List<GenreModel>? genre;
  List<GalleryModel>? gallery;

  CafeDetailModel({
    this.id,
    this.nama,
    this.alamat,
    this.jamBuka,
    this.jamTutup,
    this.totalRating,
    this.fasilitas,
    this.genre,
    this.gallery,
  });

  factory CafeDetailModel.fromJson(Map<String, dynamic> json) {
    return CafeDetailModel(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      jamBuka: json['jam_buka'],
      jamTutup: json['jam_tutup'],
      totalRating: json['total_rating']?.toDouble(),
      fasilitas: json['fasilitas'] != null
          ? List<FasilitasModel>.from(
              json['fasilitas'].map((x) => FasilitasModel.fromJson(x)))
          : null,
      genre: json['genre'] != null
          ? List<GenreModel>.from(
              json['genre'].map((x) => GenreModel.fromJson(x)))
          : null,
      gallery: json['gallery'] != null
          ? List<GalleryModel>.from(
              json['gallery'].map((x) => GalleryModel.fromJson(x)))
          : null,
    );
  }
}

class FasilitasModel {
  String? nama;

  FasilitasModel({this.nama});

  factory FasilitasModel.fromJson(Map<String, dynamic> json) {
    return FasilitasModel(nama: json['nama']);
  }
}

class GenreModel {
  String? nama;

  GenreModel({this.nama});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(nama: json['nama']);
  }
}

class GalleryModel {
  String? url;
  String? type;

  GalleryModel({this.url, this.type});

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      url: json['url'],
      type: json['type'],
    );
  }
}

class BookmarkRequest {
  String userId;
  String kafeId;

  BookmarkRequest({required this.userId, required this.kafeId});

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'kafe_id': kafeId,
    };
  }
}

class RatingRequest {
  String userId;
  String kafeId;
  int rate;

  RatingRequest({
    required this.userId,
    required this.kafeId,
    required this.rate,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'kafe_id': kafeId,
      'rate': rate,
    };
  }
}