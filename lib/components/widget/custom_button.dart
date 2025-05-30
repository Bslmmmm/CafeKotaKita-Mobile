import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';

class CustomHomeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final double borderRadius;
  // final double width;
  // final double height;
  final TextStyle? textStyle;

  const CustomHomeButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    this.borderRadius = 10,
    // this.width = 120,
    // this.height = 50,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: textStyle ??
                  AppTextStyles.interBody(
                    color: textColor,
                    weight: AppTextStyles.semiBold,
                    fontSize: 14
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
