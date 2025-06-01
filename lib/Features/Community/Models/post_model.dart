import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String username;
  final String caption;
  final String? imageUrl;
  final String? mood;
  final String? location;
  final String? sharedMenuId;
  final String? profileImageUrl;
  final String? userTag;
  final DateTime timestamp;

  // 👇 Tambahan untuk fitur interaksi
  final List<String> likedBy;
  final int likeCount;
  final int commentCount;
  final int retweetCount;
  final int viewCount;

  DateTime? createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.caption,
    this.imageUrl,
    this.mood,
    this.location,
    this.sharedMenuId,
    this.profileImageUrl,
    this.userTag,
    required this.timestamp,

    // 👇 Default value jika tidak ada di Firestore
    this.likedBy = const [],
    this.likeCount = 0,
    this.commentCount = 0,
    this.retweetCount = 0,
    this.viewCount = 0,
  });

  factory PostModel.fromMap(Map<String, dynamic> data, String documentId) {
    return PostModel(
      id: documentId,
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      caption: data['caption'] ?? '',
      imageUrl: data['imageUrl'],
      mood: data['mood'],
      location: data['location'],
      sharedMenuId: data['sharedMenuId'],
      profileImageUrl: data['profileImageUrl'],
      userTag: data['userTag'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),

      // 👇 Tambahan parsing interaksi
      likedBy: List<String>.from(data['likedBy'] ?? []),
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      retweetCount: data['retweetCount'] ?? 0,
      viewCount: data['viewCount'] ?? 0,
    );
  }

  get userProfileImage => null;

  get sharesCount => null;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'caption': caption,
      'imageUrl': imageUrl,
      'mood': mood,
      'location': location,
      'sharedMenuId': sharedMenuId,
      'profileImageUrl': profileImageUrl,
      'userTag': userTag,
      'timestamp': timestamp,

      // 👇 Tambahan ke Firestore
      'likedBy': likedBy,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'retweetCount': retweetCount,
      'viewCount': viewCount,
    };
  }
}
