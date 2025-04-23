import 'package:flutter/material.dart';
import '../Widgets/profile_header.dart';
import '../Widgets/post_card.dart'; // kita pakai ulang post_card yang sudah kamu buat
import '../Models/post_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onBack() {
    Navigator.pop(context);
  }

  void _onEditProfile() {
    // Arahkan ke halaman edit profil jika ada
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Edit profile diklik')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeader(
              username: 'dummyaccount21',
              userId: 'arielrezka22',
              profileImageUrl:
                  'https://i.pravatar.cc/300', // ganti dengan URL profil asli
              bio:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              posts: 250,
              followers: 65,
              following: 65,
              onBack: _onBack,
              onEditProfile: _onEditProfile,
            ),
            const SizedBox(height: 16),

            // TabBar
            TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.red,
              indicator: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30),
              ),
              tabs: const [
                Tab(text: "Postingan"),
                Tab(text: "Media"),
                Tab(text: "Bookmark"),
              ],
            ),

            // TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPostList(mediaOnly: false), // Postingan
                  _buildPostList(mediaOnly: true), // Media
                  // _buildBookmarkList(), // Bookmark
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList({required bool mediaOnly}) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return PostCard(
          post: PostModel(
            id: 'dummy_id_$index',
            userId: 'user_$index',
            username: 'dummyaccount21',
            userTag: 'arielrezka22',
            caption: 'Ini contoh caption dengan mediaOnly: $mediaOnly',
            profileImageUrl: 'https://i.pravatar.cc/300',
            imageUrl: mediaOnly ? 'https://picsum.photos/200/300' : null,
            timestamp: DateTime.now(),

            // data dummy interaksi
            likedBy: [],
            likeCount: 0,
            commentCount: 0,
            retweetCount: 0,
            viewCount: 0,
          ),
        );
      },
    );
  }
}
