import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String? selectedMood;
  final List<String> moods;
  final Function(String?) onChanged;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.moods,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedMood,
      hint: const Text('Pilih Mood'),
      items: moods.map((mood) {
        return DropdownMenuItem(
          value: mood,
          child: Text(mood),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
