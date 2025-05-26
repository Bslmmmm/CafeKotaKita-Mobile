import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tugas_flutter/Features/Community/Screens/search_screen.dart';
import 'package:tugas_flutter/Features/Homepage/views/home_screen.dart';
import '../controllers/post_controller.dart';
import '../Models/post_model.dart';
import '../Screens/profile_screen.dart';
import 'create_post_screen.dart';
import '../Widgets/navbar_top.dart';
import 'dart:io';
import '../Widgets/post_card.dart';
import 'post_detail_screen.dart'; // ← Tambahan baru

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isPosting = false;
  bool showNavbar = true;
  int selectedTabIndex = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildTabSelector() {
    return Row(
      children: [
        _buildTabButton("Untuk Anda", 0),
        _buildTabButton("Mengikuti", 1),
      ],
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.red : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.red : Colors.grey.shade300,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => _isPosting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: showNavbar ? 108 : 0,
            child: Column(
              children: [
                NavbarTop(
                  onProfileTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfileScreen()),
                    );
                  },
                  onSearchTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SearchScreen()),
                    );
                  },
                ),
                _buildTabSelector(),
              ],
            ),
          ),
          if (_isPosting) ...[
            const LinearProgressIndicator(minHeight: 4),
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
                        controller: _scrollController,
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PostDetailScreen(post: post),
                                ),
                              );
                            },
                            child: PostCard(post: post),
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
