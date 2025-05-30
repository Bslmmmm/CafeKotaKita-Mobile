import 'package:flutter/material.dart';

class CommentScreen extends StatelessWidget {
  final String postId;

  const CommentScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Komentar')),
      body: const Center(child: Text('Komentar akan muncul di sini.')),
    );
  }
}
