// lib/Features/SavedCafe/widgets/saved_cafe_header.dart
import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';
import 'package:KafeKotaKita/components/widget/custom_btnback.dart';

class SavedCafeHeader extends StatelessWidget {
  const SavedCafeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 16),
      color: white,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: CustomBackButton(),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: primaryc,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'Saved Cafe',
                  style: AppTextStyles.montserratBody(
                    color: white,
                    fontSize: 20,
                    weight: AppTextStyles.semiBold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}