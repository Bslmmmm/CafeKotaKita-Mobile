import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Constant/colors.dart';

class CustomNavBar extends StatefulWidget {
  final int initialSelectedIndex;
  final Function(int) onItemSelected;

  const CustomNavBar({
    super.key,
    this.initialSelectedIndex = 0,
    required this.onItemSelected,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.home_outlined, 'Home'),
            _buildNavItem(1, Icons.bookmark, 'Bookmark'),
            _buildNavItem(2, Icons.people_alt_outlined, 'People'),
            _buildNavItem(3, Icons.person_outline, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;

    return Container(
      width: 70,
      height: 80,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lingkaran hitam yang lebih besar saat tombol aktif
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutQuart,
            width: isSelected ? 70 : 0,
            height: isSelected ? 55 : 0,
            decoration: const BoxDecoration(
              color: primaryc,
              shape: BoxShape.circle,
            ),
          ),

          // Ikon yang lebih besar saat aktif
          IconButton(
            padding: EdgeInsets.zero,
            iconSize: isSelected ? 40 : 26,
            icon: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black54,
            ),
            onPressed: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onItemSelected(index);
            },
          ),
        ],
      ),
    );
  }
}
