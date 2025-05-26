import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_flutter/Features/Community/Models/post_model.dart';

class PostDetailScreen extends StatelessWidget {
  final PostModel post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('HH.mm dd/MM/yy');

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Postingan'),
        actions: const [
          Icon(Icons.more_horiz),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post.profileImageUrl ?? ''),
                  radius: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '@${post.userTag}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {},
                  child: const Text('Follow'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.caption,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(post.imageUrl!),
              ),
            const SizedBox(height: 12),
            Text(
              dateFormat.format(post.timestamp),
              style: TextStyle(color: Colors.grey[600]),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionIcon(Icons.favorite_border, post.likeCount),
                _buildActionIcon(
                    Icons.mode_comment_outlined, post.commentCount),
                _buildActionIcon(Icons.repeat, post.retweetCount),
                _buildActionIcon(Icons.bar_chart, post.viewCount),
                const Icon(Icons.bookmark_border),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 4),
        Text(_formatCount(count)),
      ],
    );
  }

  String _formatCount(int number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}jt';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}rb';
    return number.toString();
  }
}
