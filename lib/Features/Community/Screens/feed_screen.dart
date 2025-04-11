import 'package:flutter/material.dart';
import '../controllers/post_controller.dart';
import '../Models/post_model.dart';
import 'create_post_screen.dart';
import 'dart:io';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isPosting = false;

  Widget _buildPostItem(PostModel post) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.username,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(post.caption),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(post.imageUrl!),
              ),
            ],
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (post.mood != null) Text('Mood: ${post.mood}'),
                if (post.location != null) Text('Lokasi: ${post.location}'),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${post.timestamp.toLocal()}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCreatePost(Map<String, dynamic> data) async {
    setState(() => _isPosting = true);

    try {
      await PostController().createPost(
        caption: data['caption'],
        mood: data['mood'],
        location: data['location'],
        imageFile: data['imageFile'] as File?,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memposting: $e')),
      );
    }

    // Delay kecil agar progress bar tidak terlalu instan menghilang
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => _isPosting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Komunitas KafeKotaKita')),
      body: Column(
        children: [
          if (_isPosting) const LinearProgressIndicator(minHeight: 4),
          Expanded(
            child: StreamBuilder<List<PostModel>>(
              stream: PostController().getPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Terjadi kesalahan: ${snapshot.error}'));
                } else {
                  final posts = snapshot.data ?? [];
                  if (posts.isEmpty) {
                    return const Center(child: Text('Belum ada postingan.'));
                  }

                  return RefreshIndicator(
                    onRefresh: () async => setState(() {}),
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) =>
                          _buildPostItem(posts[index]),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostScreen()),
          );

          if (result != null && result is Map<String, dynamic>) {
            await _handleCreatePost(result);
          }
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
