import 'package:flutter/material.dart';
import 'package:tugas_flutter/Constant/colors.dart';


class CustomSearchbar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  const CustomSearchbar({
    Key?key,
    required this.controller,
    this.onChanged,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: clrbtn,
        borderRadius: BorderRadius.circular(10)
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(color: white),
        decoration: InputDecoration(
          icon: const Icon(
            Icons.search,
            color: clrfont2,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(color: clrfont2),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
