import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:KafeKotaKita/Features/Community/Models/post_model.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;
  final String? postId;

  const PostDetailScreen({super.key, required this.post, this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State untuk like dan interaksi
  bool isLiked = false;
  bool isRetweeted = false;
  bool isBookmarked = false;
  int likeCount = 0;
  int retweetCount = 0;

  @override
  void initState() {
    super.initState();
    // Inisialisasi counts
    likeCount = widget.post.likeCount;
    retweetCount = widget.post.retweetCount;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleBackPressed() {
    // Pastikan kembali ke screen sebelumnya dengan hasil yang tepat
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('HH.mm dd/MM/yy');

    return WillPopScope(
      onWillPop: () async {
        // Handle system back button
        _handleBackPressed();
        return false; // Prevent default back action
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: _handleBackPressed, // Use the custom handler
          ),
          title: const Text(
            'Postingan',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dengan profil user
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage:
                                widget.post.profileImageUrl != null &&
                                        widget.post.profileImageUrl!.isNotEmpty
                                    ? NetworkImage(widget.post.profileImageUrl!)
                                    : null,
                            child: (widget.post.profileImageUrl == null ||
                                    widget.post.profileImageUrl!.isEmpty)
                                ? const Icon(Icons.person, color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '@${widget.post.userTag}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 0,
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Follow',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Konten post
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.post.caption,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Gambar post jika ada
                    if (widget.post.imageUrl != null &&
                        widget.post.imageUrl!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        constraints: const BoxConstraints(maxHeight: 400),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.post.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: Colors.grey, size: 50),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Timestamp
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        dateFormat.format(widget.post.timestamp),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Action buttons
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            likeCount,
                            isLiked ? Colors.red : Colors.grey.shade600,
                            () => _toggleLike(),
                          ),
                          _buildActionButton(
                            Icons.chat_bubble_outline,
                            widget.post.commentCount,
                            Colors.grey.shade600,
                            () {},
                          ),
                          _buildActionButton(
                            Icons.repeat,
                            retweetCount,
                            isRetweeted ? Colors.green : Colors.grey.shade600,
                            () => _toggleRetweet(),
                          ),
                          _buildActionButton(
                            Icons.bar_chart_outlined,
                            widget.post.viewCount,
                            Colors.grey.shade600,
                            () {},
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => _toggleBookmark(),
                                icon: Icon(
                                  isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: isBookmarked
                                      ? Colors.blue
                                      : Colors.grey.shade600,
                                  size: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.share_outlined,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Section komentar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('posts')
                            .doc(widget.post.id)
                            .collection('comments')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              child: const Text(
                                "Gagal memuat komentar",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final comments = snapshot.data!.docs;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: comments.map((comment) {
                              final data =
                                  comment.data() as Map<String, dynamic>;
                              return _buildCommentItem(data);
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Input komentar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        FirebaseAuth.instance.currentUser?.photoURL != null
                            ? NetworkImage(
                                FirebaseAuth.instance.currentUser!.photoURL!)
                            : null,
                    child: FirebaseAuth.instance.currentUser?.photoURL == null
                        ? const Icon(Icons.person, size: 16, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: "Tulis komentar...",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: _submitComment,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, int count, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 4),
          Text(
            _formatCount(count),
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: data['profileImageUrl'] != null &&
                    data['profileImageUrl'].toString().isNotEmpty
                ? NetworkImage(data['profileImageUrl'])
                : null,
            child: (data['profileImageUrl'] == null ||
                    data['profileImageUrl'].toString().isEmpty)
                ? const Icon(Icons.person, size: 16, color: Colors.grey)
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
                      data['username'] ?? 'Anonim',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '@${data['username'] ?? 'unknown'}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat.Hm()
                          .format((data['timestamp'] as Timestamp).toDate()),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  data['text'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}k';
    return number.toString();
  }

  void _toggleLike() {
    setState(() {
      if (isLiked) {
        isLiked = false;
        likeCount--;
      } else {
        isLiked = true;
        likeCount++;
      }
    });
  }

  void _toggleRetweet() {
    setState(() {
      if (isRetweeted) {
        isRetweeted = false;
        retweetCount--;
      } else {
        isRetweeted = true;
        retweetCount++;
      }
    });
  }

  void _toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  void _submitComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('posts')
          .doc(widget.post.id)
          .collection('comments')
          .add({
        'text': commentText,
        'userId': user.uid,
        'username': user.displayName ?? 'Pengguna',
        'profileImageUrl': user.photoURL ?? '',
        'timestamp': Timestamp.now(),
      });

      _commentController.clear();

      // Menampilkan feedback sukses
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Komentar berhasil ditambahkan'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan komentar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
