// lib/features/onboarding/view/onboarding_content.dart
import 'package:flutter/material.dart';
import '../../../Constant/textstyle.dart';

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 264),
        const SizedBox(height: 28),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.poppinsBody(
              fontSize: 40,
              weight: AppTextStyles.extrabold,
              color: Colors.black),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.poppinsBody(
              fontSize: 18, weight: AppTextStyles.medium, color: Colors.black),
        ),
      ],
    );
  }
}
