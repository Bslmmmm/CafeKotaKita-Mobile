import 'package:flutter/material.dart';

class RepostDropdown extends StatelessWidget {
  final VoidCallback onRepost;
  final VoidCallback onQuote;

  const RepostDropdown({
    super.key,
    required this.onRepost,
    required this.onQuote,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'repost') onRepost();
        if (value == 'quote') onQuote();
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'repost', child: Text('Repost')),
        const PopupMenuItem(value: 'quote', child: Text('Quote Post')),
      ],
    );
  }
}
