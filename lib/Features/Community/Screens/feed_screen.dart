import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:KafeKotaKita/Features/Community/Screens/create_post_screen.dart';
import 'package:KafeKotaKita/Features/Community/Screens/post_detail_screen.dart';
import 'package:KafeKotaKita/Features/Community/Screens/profile_screen.dart';
import 'package:KafeKotaKita/Features/Community/Screens/search_screen.dart';
import 'package:KafeKotaKita/Features/Community/Widgets/navbar_top.dart';
import 'package:KafeKotaKita/Features/Community/Widgets/post_card.dart';
import 'package:KafeKotaKita/Features/Community/controllers/post_controller.dart';
import 'package:KafeKotaKita/Features/Community/Models/post_model.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with TickerProviderStateMixin {
  bool _isPosting = false;
  bool showNavbar = true;
  int selectedTabIndex = 0;

  final ScrollController _scrollController = ScrollController();

  // Maps untuk menyimpan state like dan retweet untuk setiap post
  Map<String, bool> likedPosts = {};
  Map<String, bool> retweetedPosts = {};
  Map<String, int> likeCounts = {};
  Map<String, int> retweetCounts = {};

  @override
  void initState() {
    super.initState();
    // Add scroll listener for better performance
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Optional: Add scroll position tracking or additional logic here
  }

  // Fungsi untuk toggle like
  void _toggleLike(String postId, int originalLikeCount) {
    setState(() {
      if (likedPosts[postId] == true) {
        // Unlike
        likedPosts[postId] = false;
        likeCounts[postId] = (likeCounts[postId] ?? originalLikeCount) - 1;
      } else {
        // Like
        likedPosts[postId] = true;
        likeCounts[postId] = (likeCounts[postId] ?? originalLikeCount) + 1;
      }
    });
  }

  // Fungsi untuk toggle retweet
  void _toggleRetweet(String postId, int originalRetweetCount) {
    setState(() {
      if (retweetedPosts[postId] == true) {
        // Un-retweet
        retweetedPosts[postId] = false;
        retweetCounts[postId] =
            (retweetCounts[postId] ?? originalRetweetCount) - 1;
      } else {
        // Retweet
        retweetedPosts[postId] = true;
        retweetCounts[postId] =
            (retweetCounts[postId] ?? originalRetweetCount) + 1;
      }
    });
  }

  // Fixed navbar without center logo
  Widget _buildFixedNavbar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile button
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              );
              if (mounted) _refreshPosts();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.person_outline,
                size: 20,
                color: Colors.black87,
              ),
            ),
          ),
          
          // Title
          const Text(
            'Feed',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          
          // Search button with black color
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black, // Changed to black
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fixed tab selector to prevent overflow
  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _buildTabButton("Untuk Anda", 0)),
          const SizedBox(width: 12),
          Expanded(child: _buildTabButton("Mengikuti", 1)),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildModernPostCard(PostModel post) {
    // Inisialisasi state untuk post ini jika belum ada
    if (!likeCounts.containsKey(post.id)) {
      likeCounts[post.id] = post.likeCount;
    }
    if (!retweetCounts.containsKey(post.id)) {
      retweetCounts[post.id] = post.sharesCount ?? 0;
    }

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
                  backgroundImage: post.userProfileImage != null
                      ? NetworkImage(post.userProfileImage!)
                      : null,
                  child: post.userProfileImage == null
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
                            post.username ?? 'dummyaccount21',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '@${post.username ?? 'aerlenska22'}',
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
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Post content
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

          // Post image
          if (post.imageUrl != null)
            Container(
              margin: const EdgeInsets.only(top: 12),
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
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey, size: 50),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildLikeButton(post),
                const SizedBox(width: 24),
                _buildActionButton(
                  Icons.chat_bubble_outline,
                  post.commentCount?.toString() ?? '0',
                  () {
                    // Navigate ke detail untuk comment
                    _navigateToDetail(post);
                  },
                ),
                const SizedBox(width: 24),
                _buildRetweetButton(post),
                const SizedBox(width: 24),
                _buildActionButton(
                  Icons.remove_red_eye_outlined,
                  _formatViewCount(post.viewCount ?? 0),
                  () {},
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border, size: 20),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikeButton(PostModel post) {
    final isLiked = likedPosts[post.id] ?? false;
    final likeCount = likeCounts[post.id] ?? post.likeCount;

    return GestureDetector(
      onTap: () => _toggleLike(post.id, post.likeCount),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(isLiked),
              size: 20,
              color: isLiked ? Colors.red : Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            likeCount.toString(),
            style: TextStyle(
              color: isLiked ? Colors.red : Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetweetButton(PostModel post) {
    final isRetweeted = retweetedPosts[post.id] ?? false;
    final retweetCount = retweetCounts[post.id] ?? (post.sharesCount ?? 0);

    return GestureDetector(
      onTap: () => _toggleRetweet(post.id, post.sharesCount ?? 0),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.repeat,
              key: ValueKey(isRetweeted),
              size: 20,
              color: isRetweeted ? Colors.green : Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            retweetCount.toString(),
            style: TextStyle(
              color: isRetweeted ? Colors.green : Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return '2 jam';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  String _formatViewCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  void _navigateToDetail(PostModel post) async {
    // Increment view count
    PostController().incrementViewCount(post.id);

    // Navigate to detail screen and wait for result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(
          post: post,
          postId: post.id,
        ),
      ),
    );

    // Handle any result from PostDetailScreen if needed
    if (result != null && mounted) {
      // Handle returned data if PostDetailScreen sends any data back
      // For example, if post was updated, deleted, etc.
      setState(() {
        // Refresh or update state if needed
      });
    }
  }

  Future<void> _handleCreatePost(Map<String, dynamic> data) async {
    if (!mounted) return;

    setState(() => _isPosting = true);
    try {
      await PostController().createPost(
        caption: data['caption'],
        mood: data['mood'],
        location: data['location'],
        imageFile: data['imageFile'] as File?,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post berhasil dibuat!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memposting: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => _isPosting = false);
  }

  Future<void> _refreshPosts() async {
    // Clear cached states and refresh
    likedPosts.clear();
    retweetedPosts.clear();
    likeCounts.clear();
    retweetCounts.clear();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Fixed navbar without center logo
          _buildFixedNavbar(),
          
          // Tab selector with proper spacing
          _buildTabSelector(),
          
          if (_isPosting) ...[
            const LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ],
          
          Expanded(
            child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.direction == ScrollDirection.reverse) {
                  if (showNavbar) setState(() => showNavbar = false);
                } else if (notification.direction == ScrollDirection.forward) {
                  if (!showNavbar) setState(() => showNavbar = true);
                }
                return true;
              },
              child: StreamBuilder<List<PostModel>>(
                stream: PostController().getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Terjadi kesalahan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.error}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refreshPosts,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    final posts = snapshot.data ?? [];
                    if (posts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.post_add,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada postingan.',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Buat postingan pertama Anda!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _refreshPosts,
                      color: Colors.black,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return GestureDetector(
                            onTap: () => _navigateToDetail(post),
                            child: _buildModernPostCard(post),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.black, Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          heroTag: "createPost", // Add unique hero tag
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CreatePostScreen(),
              ),
            );

            if (result != null && result is Map<String, dynamic>) {
              await _handleCreatePost(result);
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}