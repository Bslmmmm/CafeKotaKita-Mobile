import 'package:cloud_firestore/cloud_firestore.dart';

class RepostController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> repost(String userId, String originalPostId) async {
    String newId = DateTime.now().millisecondsSinceEpoch.toString();
    await _firestore.collection('posts').doc(newId).set({
      'id': newId,
      'userId': userId,
      'originalPostId': originalPostId,
      'timestamp': DateTime.now(),
      'isRepost': true,
    });
  }

  // TODO: Implement retweetPost logic if needed
  void retweetPost(String id, String currentUserId) {
    // Kosong dulu
  }
}
