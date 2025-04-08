import 'package:flutter/material.dart';
import '../Models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.username,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(post.caption),
            if (post.imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Image.network(post.imageUrl!),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (post.mood != null) Text("Mood: ${post.mood!}"),
                const SizedBox(width: 16),
                if (post.location != null) Text("📍 ${post.location!}"),
              ],
            ),
            const SizedBox(height: 4),
            Text(post.timestamp.toString(),
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
