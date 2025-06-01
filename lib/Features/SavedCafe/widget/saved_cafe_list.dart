// lib/Features/SavedCafe/widgets/saved_cafe_list.dart
import 'package:KafeKotaKita/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Features/SavedCafe/model/model_saved_cafe.dart';
import 'package:KafeKotaKita/components/widget/custom_card_cafe.dart';
import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:get/get.dart';

class SavedCafeList extends StatelessWidget {
  final List<SavedCafeItem> cafes;
  final Future<void> Function() onRefresh;
  final void Function(SavedCafeItem cafe)? onCafeTap;

  const SavedCafeList({
    super.key,
    required this.cafes,
    required this.onRefresh,
    this.onCafeTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: primaryc,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: cafes.length,
        itemBuilder: (context, index) {
          final cafe = cafes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomCardCafe(
              cafeimgurl: cafe.imageUrl,
              namacafe: cafe.cafename,
              lokasi: cafe.alamat,
              jambuka: cafe.jambuka,
              jamtutup: cafe.jamtutup,
              rating: cafe.rating,
              isOpen: cafe.isOpen,
              Id: cafe.id,
              onTap: () {
                Get.toNamed(AppRoutes.detailcafe,
                arguments: cafe.id);
              },
            ),
          );
        },
      ),
    );
  }
}