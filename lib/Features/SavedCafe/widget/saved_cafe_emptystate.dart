// lib/Features/SavedCafe/widgets/saved_cafe_empty_state.dart
import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';

class SavedCafeEmptyState extends StatelessWidget {
  final VoidCallback? onSearchPressed;
  
  const SavedCafeEmptyState({
    super.key,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: primaryc.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.bookmark_outline,
              color: primaryc,
              size: 50,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Cafe Tersimpan',
            style: AppTextStyles.poppinsBody(
              color: primaryc,
              fontSize: 18,
              weight: AppTextStyles.semiBold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan cafe favorit kamu\nagar mudah ditemukan kembali',
            textAlign: TextAlign.center,
            style: AppTextStyles.interBody(
              color: primaryc.withOpacity(0.7),
              fontSize: 14,
              weight: AppTextStyles.regular,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onSearchPressed ?? () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryc,
              foregroundColor: white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Cari Cafe',
              style: AppTextStyles.interBody(
                color: white,
                fontSize: 14,
                weight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}