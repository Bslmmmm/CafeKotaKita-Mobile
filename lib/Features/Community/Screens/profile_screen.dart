import 'package:flutter/material.dart';
import '../Widgets/post_card.dart';
import '../Models/post_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  int selectedTabIndex = 0;
  bool _isHeaderVisible = true;
  double _headerHeight = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();

    _tabController.addListener(() {
      setState(() {
        selectedTabIndex = _tabController.index;
      });
    });

    _scrollController.addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final scrollOffset = _scrollController.offset;
      const hideThreshold = 100.0; // Scroll threshold untuk hide/show

      // Hide header saat scroll down, show saat scroll up atau di top
      bool shouldHideHeader = scrollOffset > hideThreshold;

      if (shouldHideHeader != !_isHeaderVisible) {
        setState(() {
          _isHeaderVisible = !shouldHideHeader;
        });
      }
    }
  }

  void _onBack() {
    Navigator.pop(context);
  }

  void _onEditProfile() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Edit profile diklik')));
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey.shade400,
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Top Bar with Back Button and Username
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _onBack,
                  child: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'dummyaccount21',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Profile Info Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage:
                      const NetworkImage('https://i.pravatar.cc/300'),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Username Handle
                Text(
                  '@arielrezka22',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatsItem('250', 'Postingan'),
                    _buildStatsItem('65', 'Follower'),
                    _buildStatsItem('65', 'Following'),
                  ],
                ),
                const SizedBox(height: 20),

                // Bio
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onEditProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Tab Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildTabButton("Postingan", 0),
                const SizedBox(width: 8),
                _buildTabButton("Media", 1),
                const SizedBox(width: 8),
                _buildTabButton("Bookmark", 2),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content with Custom ScrollView
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Header sebagai Sliver
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),

                // Tab Content
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPostList(mediaOnly: false), // Postingan
                      _buildPostList(mediaOnly: true), // Media
                      _buildBookmarkList(), // Bookmark
                    ],
                  ),
                ),
              ],
            ),

            // Floating Mini Header (shown when main header is hidden)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: _isHeaderVisible ? -80 : 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _onBack,
                        child: const Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Mini Profile Info
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage:
                            const NetworkImage('https://i.pravatar.cc/300'),
                      ),
                      const SizedBox(width: 12),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'dummyaccount21',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '250 Postingan',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList({required bool mediaOnly}) {
    // Sample posts data
    final posts = [
      PostModel(
        id: 'dummy_id_1',
        userId: 'user_1',
        username: 'dummyaccount21',
        userTag: 'arielrezka22',
        caption:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        profileImageUrl: 'https://i.pravatar.cc/300',
        imageUrl: null,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likedBy: [],
        likeCount: 361,
        commentCount: 45,
        retweetCount: 50,
        viewCount: 128300,
        mood: '😀',
      ),
      PostModel(
        id: 'dummy_id_2',
        userId: 'user_2',
        username: 'dummyaccount21',
        userTag: 'arielrezka22',
        caption:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        profileImageUrl: 'https://i.pravatar.cc/300',
        imageUrl:
            'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&h=600&fit=crop',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likedBy: [],
        likeCount: 361,
        commentCount: 45,
        retweetCount: 50,
        viewCount: 128300,
        mood: '🥰',
      ),
    ];

    // Filter posts based on mediaOnly flag
    final filteredPosts = mediaOnly
        ? posts.where((post) => post.imageUrl != null).toList()
        : posts;

    if (filteredPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              mediaOnly ? Icons.photo : Icons.post_add,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              mediaOnly ? 'Belum ada media' : 'Belum ada postingan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredPosts.length,
      itemBuilder: (context, index) {
        return PostCard(post: filteredPosts[index]);
      },
    );
  }

  Widget _buildBookmarkList() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Belum ada bookmark',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
