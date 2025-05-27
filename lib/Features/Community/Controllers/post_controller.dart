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

  // Buat post baru
  Future<void> createPost({
    required String caption,
    String? mood,
    String? location,
    File? imageFile,
  }) async {
    try {
      String postId = DateTime.now().millisecondsSinceEpoch.toString();
      String userId = 'dummyUserId'; // Nanti ganti pakai FirebaseAuth
      String username = 'dummyUsername'; // Nanti juga dari FirebaseAuth
      String? imageUrl;

      if (imageFile != null) {
        try {
          final ref = _storage.ref().child('post_images').child('$postId.jpg');
          final uploadTask = ref.putFile(imageFile);

          final snapshot = await uploadTask.whenComplete(() => null);

          if (snapshot.state == TaskState.success) {
            imageUrl = await ref.getDownloadURL();
          } else {
            throw Exception('Upload gagal: ${snapshot.state}');
          }
        } catch (e) {
          print('Gagal upload gambar: $e');
          rethrow;
        }
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

  // Toggle like pada post
  Future<void> toggleLike(String postId, String userId) async {
    final postRef = _postCollection.doc(postId);

    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(postRef);

        if (!snapshot.exists) return;

        final data = snapshot.data() as Map<String, dynamic>;
        final likedBy = List<String>.from(data['likedBy'] ?? []);
        int likeCount = data['likeCount'] ?? 0;

        if (likedBy.contains(userId)) {
          likedBy.remove(userId);
          likeCount--;
        } else {
          likedBy.add(userId);
          likeCount++;
        }

        transaction.update(postRef, {
          'likedBy': likedBy,
          'likeCount': likeCount,
        });
      });
    } catch (e) {
      print('Gagal toggle like: $e');
      rethrow;
    }
  }

  // Tambahkan jumlah view ke post
  Future<void> incrementViewCount(String id) async {
    try {
      final postRef = _postCollection.doc(id);
      await postRef.update({
        'viewCount': FieldValue.increment(1),
      });
    } catch (e) {
      print('Gagal menambah view count: $e');
      rethrow;
    }
  }
}
