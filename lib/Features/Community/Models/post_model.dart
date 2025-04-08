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
  final DateTime timestamp;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.caption,
    this.imageUrl,
    this.mood,
    this.location,
    this.sharedMenuId,
    required this.timestamp,
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
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'caption': caption,
      'imageUrl': imageUrl,
      'mood': mood,
      'location': location,
      'sharedMenuId': sharedMenuId,
      'timestamp': timestamp,
    };
  }
}
