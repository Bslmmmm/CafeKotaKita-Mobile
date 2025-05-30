import 'package:flutter/material.dart';

class ProfileTabs extends StatelessWidget {
  final TabController controller;

  const ProfileTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      tabs: const [
        Tab(text: 'Saran'),
        Tab(text: 'Mengikuti'),
      ],
    );
  }
}
