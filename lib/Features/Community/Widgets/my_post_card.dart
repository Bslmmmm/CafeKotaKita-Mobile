import 'package:flutter/material.dart';

class MyPostCard extends StatelessWidget {
  final String caption;

  const MyPostCard({super.key, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(caption),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }
}
