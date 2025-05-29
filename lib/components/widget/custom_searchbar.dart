import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';

class CustomSearchbar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final TextStyle? hintText;
  const CustomSearchbar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration:
          BoxDecoration(color: clrbtn, borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(color: white),
        decoration: InputDecoration(
          icon: SvgPicture.asset(
            'assets/Icons/search.svg',
            colorFilter: ColorFilter.mode(clrfont2, BlendMode.srcIn),
            width: 16,
            height: 16,
          ),
          hintText: 'Search',
          hintStyle: AppTextStyles.interBody(
              color: clrfont2, weight: AppTextStyles.semiBold, fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
