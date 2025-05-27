import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tugas_flutter/Features/Community/Models/post_model.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.post.profileImageUrl ?? ''),
                      radius: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '@${widget.post.userTag}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                  widget.post.caption,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                if (widget.post.imageUrl != null &&
                    widget.post.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(widget.post.imageUrl!),
                  ),
                const SizedBox(height: 12),
                Text(
                  dateFormat.format(widget.post.timestamp),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionIcon(
                        Icons.favorite_border, widget.post.likeCount),
                    _buildActionIcon(
                        Icons.mode_comment_outlined, widget.post.commentCount),
                    _buildActionIcon(Icons.repeat, widget.post.retweetCount),
                    _buildActionIcon(Icons.bar_chart, widget.post.viewCount),
                    const Icon(Icons.bookmark_border),
                  ],
                ),
                const Divider(height: 24),
                const Text(
                  "Komentar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('posts')
                      .doc(widget.post.id)
                      .collection('comments')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Gagal memuat komentar");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final comments = snapshot.data!.docs;

                    if (comments.isEmpty) {
                      return const Text("Belum ada komentar.");
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final data = comment.data() as Map<String, dynamic>;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading:
                              const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(data['username'] ?? 'Anonim'),
                          subtitle: Text(data['text'] ?? ''),
                          trailing: Text(
                            DateFormat.Hm().format(
                                (data['timestamp'] as Timestamp).toDate()),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Tulis komentar...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _submitComment,
                ),
              ],
            ),
          ),
        ],
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

  void _submitComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    try {
      await _firestore
          .collection('posts')
          .doc(widget.post.id)
          .collection('comments')
          .add({
        'text': commentText,
        'userId': 'dummyUserId', // ganti nanti dengan FirebaseAuth
        'username': 'dummyUsername', // ganti nanti dengan FirebaseAuth
        'timestamp': Timestamp.now(),
      });

      _commentController.clear();
    } catch (e) {
      print('Gagal menambahkan komentar: $e');
    }
  }
}
