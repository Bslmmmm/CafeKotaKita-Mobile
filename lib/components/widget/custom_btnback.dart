import 'package:flutter/material.dart';
import 'package:tugas_flutter/Constant/colors.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  
  const CustomBackButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: primaryc,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: white,
          size: 20,
        ),
      ),
    );
  }
}