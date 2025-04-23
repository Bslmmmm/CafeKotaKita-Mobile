import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String userId;
  final String profileImageUrl;
  final String bio;
  final int posts;
  final int followers;
  final int following;
  final VoidCallback onBack;
  final VoidCallback onEditProfile;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.userId,
    required this.profileImageUrl,
    required this.bio,
    required this.posts,
    required this.followers,
    required this.following,
    required this.onBack,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Back & username
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack,
              ),
              Text(
                username,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),

        // Profile Image
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(profileImageUrl),
        ),
        const SizedBox(height: 8),

        // User ID
        Text(
          '@$userId',
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 12),

        // Stats: Posts, Followers, Following
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStat('Postingan', posts),
            _buildStat('Follower', followers),
            _buildStat('Following', following),
          ],
        ),
        const SizedBox(height: 12),

        // Bio
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            bio,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),

        // Edit Profile button
        ElevatedButton(
          onPressed: onEditProfile,
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            backgroundColor: Colors.red[400],
          ),
          child: const Text("Edit Profile"),
        ),
      ],
    );
  }

  Widget _buildStat(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
