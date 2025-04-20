import 'package:flutter/material.dart';
import '../Models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 24,
            backgroundImage: post.profileImageUrl != null
                ? NetworkImage(post.profileImageUrl!)
                : const AssetImage('assets/default_profile.png')
                    as ImageProvider,
          ),
          const SizedBox(width: 12),
          // Post Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and tag
                Row(
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '@${post.userTag ?? post.userId}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    Icon(Icons.more_vert, size: 18, color: Colors.grey[600]),
                  ],
                ),
                const SizedBox(height: 4),
                // Caption
                Text(post.caption),
                const SizedBox(height: 6),
                // Optional image
                if (post.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      post.imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 8),
                // Location & Mood
                Row(
                  children: [
                    if (post.location != null)
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 14, color: Colors.grey),
                          Text(post.location!,
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    const SizedBox(width: 12),
                    if (post.mood != null)
                      Text("Mood: ${post.mood!}",
                          style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.comment_outlined, size: 18),
                    Icon(Icons.repeat, size: 18),
                    Icon(Icons.favorite_border, size: 18),
                    Icon(Icons.remove_red_eye_outlined, size: 18),
                    Icon(Icons.bookmark_border, size: 18),
                    Icon(Icons.share_outlined, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
