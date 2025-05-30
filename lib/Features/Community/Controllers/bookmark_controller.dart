import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleBookmark(String userId, String postId) async {
    final ref = _firestore.collection('users').doc(userId);
    final snapshot = await ref.get();
    final data = snapshot.data();

    if (data != null) {
      List<String> saved = List<String>.from(data['savedPosts'] ?? []);
      if (saved.contains(postId)) {
        saved.remove(postId);
      } else {
        saved.add(postId);
      }
      await ref.update({'savedPosts': saved});
    }
  }
}
