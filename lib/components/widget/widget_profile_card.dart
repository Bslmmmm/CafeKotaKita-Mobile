import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Constant/colors.dart';

class ProfileCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? margin;

  const ProfileCard({
    Key? key,
    required this.children,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: primaryc, 
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

// Widget untuk menambahkan garis pemisah antara item di dalam card
class ProfileDivider extends StatelessWidget {
  const ProfileDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.0,
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      color: Colors.white.withOpacity(0.2),
    );
  }
}