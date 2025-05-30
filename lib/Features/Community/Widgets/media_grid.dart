import 'package:flutter/material.dart';

class MediaGrid extends StatelessWidget {
  final List<String> mediaUrls;

  const MediaGrid({super.key, required this.mediaUrls});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: mediaUrls.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return Image.network(mediaUrls[index], fit: BoxFit.cover);
      },
    );
  }
}
