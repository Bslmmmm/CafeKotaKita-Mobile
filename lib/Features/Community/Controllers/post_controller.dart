import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Models/post_model.dart';

class PostController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference get _postCollection => _firestore.collection('posts');

  // Tambahkan post ke Firestore
  Future<void> addPost(PostModel post) async {
    try {
      await _postCollection.doc(post.id).set(post.toMap());
    } catch (e) {
      print('Error saat menambahkan post: $e');
      rethrow;
    }
  }

  // Stream semua post (realtime)
  Stream<List<PostModel>> getPosts() {
    return _postCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Dapatkan post berdasarkan ID user
  Stream<List<PostModel>> getPostsByUser(String userId) {
    return _postCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Hapus post
  Future<void> deletePost(String postId) async {
    try {
      await _postCollection.doc(postId).delete();
    } catch (e) {
      print('Gagal menghapus post: $e');
      rethrow;
    }
  }

  // ✅ Tambahkan post dengan upload gambar ke Storage (jika ada)
  Future<void> createPost({
    required String caption,
    String? mood,
    String? location,
    File? imageFile,
  }) async {
    try {
      String postId = DateTime.now().millisecondsSinceEpoch.toString();
      String userId = 'dummyUserId'; // Ganti nanti sesuai FirebaseAuth
      String username = 'dummyUsername'; // Ganti nanti sesuai FirebaseAuth
      String? imageUrl;

      if (imageFile != null) {
        // Upload gambar ke Firebase Storage
        final ref = _storage.ref().child('post_images').child('$postId.jpg');
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      final newPost = PostModel(
        id: postId,
        userId: userId,
        username: username,
        caption: caption,
        mood: mood,
        location: location,
        imageUrl: imageUrl,
        timestamp: DateTime.now(),
      );

      await addPost(newPost);
    } catch (e) {
      print('Gagal membuat post: $e');
      rethrow;
    }
  }
}
