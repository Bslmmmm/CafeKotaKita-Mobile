import 'package:flutter/material.dart';

class NavbarTop extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onSearchTap;

  const NavbarTop({
    super.key,
    this.onProfileTap,
    this.onSearchTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // PROFILE
          GestureDetector(
            onTap: onProfileTap,
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150', // Ganti dengan user.profilePic!
              ),
            ),
          ),
          // LOGO
          Image.asset(
            'assets/images/icon.png',
            height: 32,
          ),
          // SEARCH
          IconButton(
            onPressed: onSearchTap,
            icon: const Icon(Icons.search, color: Color(0xFFB13841)),
          )
        ],
      ),
    );
  }
}
