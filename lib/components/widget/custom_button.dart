import 'package:flutter/material.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';

class CustomHomeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final double borderRadius;
  final double width;
  final double height;
  final TextStyle? textStyle;

  const CustomHomeButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    this.borderRadius = 10,
    this.width = 140,
    this.height = 50,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(width: 8),
            Text(
              label,
              textAlign: TextAlign.left,
              style: textStyle ??
                  AppTextStyles.interBody(
                    color: textColor,
                    weight: AppTextStyles.semiBold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
