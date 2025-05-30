import 'package:flutter/material.dart';

class SavedPostScreen extends StatelessWidget {
  const SavedPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post yang Disimpan')),
      body: const Center(child: Text('Daftar post tersimpan.')),
    );
  }
}
