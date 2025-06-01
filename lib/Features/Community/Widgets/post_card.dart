import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Features/Community/Controllers/post_controller.dart';
import '../Models/post_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Screens/comments_screen.dart';
import '../Screens/post_detail_screen.dart';
import '../Controllers/repost_controller.dart';

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

  void goToComments() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentScreen(postId: widget.post.id),
      ),
    );
  }

  void retweetPost() async {
    try {
      RepostController().retweetPost(widget.post.id, currentUserId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil me-retweet.")),
      );
    } catch (e) {
      print("Error retweet: $e");
    }
  }

  void openPostDetail() async {
    await PostController().increaseViewCount(widget.post.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(
          post: widget.post,
          postId: '',
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, int count, VoidCallback? onTap,
      {Color? color, bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: isActive ? color : Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            _formatCount(count),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return '2 jam';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}j';
    } else {
      return '${difference.inDays}h';
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: post.profileImageUrl != null
                      ? NetworkImage(post.profileImageUrl!)
                      : null,
                  child: post.profileImageUrl == null
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
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
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '@${post.userTag ?? post.userId}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _formatTimeAgo(post.createdAt),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Show more options
                  },
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Post content - Clickable area
          InkWell(
            onTap: openPostDetail,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Caption
                if (post.caption.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      post.caption,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),

                // Location and mood info
                if (post.location != null || post.mood != null)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        if (post.location != null) ...[
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            post.location!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                        if (post.location != null && post.mood != null)
                          const SizedBox(width: 12),
                        if (post.mood != null)
                          Text(
                            "Mood: ${post.mood!}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),

                // Post image
                if (post.imageUrl != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        post.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 50,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildActionButton(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  likeCount,
                  toggleLike,
                  color: Colors.red,
                  isActive: isLiked,
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  Icons.chat_bubble_outline,
                  post.commentCount,
                  goToComments,
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  Icons.repeat,
                  post.retweetCount,
                  retweetPost,
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  Icons.remove_red_eye_outlined,
                  post.viewCount,
                  null,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Bookmark functionality
                  },
                  child: const Icon(
                    Icons.bookmark_border,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: onShare,
                  child: const Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
