import 'package:flutter/material.dart';
import 'package:tugas_flutter/Features/Community/Controllers/post_controller.dart';
import '../Models/post_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool isLiked;
  late int likeCount;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.likedBy.contains(currentUserId);
    likeCount = widget.post.likeCount;
  }

  void toggleLike() async {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });

    try {
      await PostController().toggleLike(widget.post.id, currentUserId);
    } catch (e) {
      print("Error toggle like: $e");
      // Optional: Kembalikan state jika gagal
      setState(() {
        isLiked = !isLiked;
        likeCount += isLiked ? 1 : -1;
      });
    }
  }

  void onShare() {
    final text = widget.post.caption;
    Share.share(text);
  }

  Widget _buildAction(IconData icon, int count, VoidCallback? onTap,
      {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color ?? Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: post.profileImageUrl != null
                ? NetworkImage(post.profileImageUrl!)
                : const AssetImage('assets/default_profile.png')
                    as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                Text(post.caption),
                const SizedBox(height: 6),
                if (post.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      post.imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 8),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAction(Icons.comment_outlined, post.commentCount, () {
                      // Navigasi ke komentar
                    }),
                    _buildAction(Icons.repeat, post.retweetCount, () {
                      // Aksi retweet
                    }),
                    _buildAction(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      likeCount,
                      toggleLike,
                      color: isLiked ? Colors.red : null,
                    ),
                    _buildAction(
                        Icons.remove_red_eye_outlined, post.viewCount, null),
                    _buildAction(Icons.bookmark_border, 0, () {
                      // Bookmark
                    }),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, size: 18),
                      onPressed: onShare,
                    ),
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
