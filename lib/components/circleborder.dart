import 'package:flutter/material.dart';
class CircleContainer extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Widget child;
  final VoidCallback? onTap;

  const CircleContainer({
    Key? key,
    required this.size,
    this.backgroundColor = Colors.black,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}