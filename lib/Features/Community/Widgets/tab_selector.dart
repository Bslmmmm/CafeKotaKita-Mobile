import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TabSelector(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTab("Untuk Anda", 0),
        _buildTab("Mengikuti", 1),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = index == currentIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
