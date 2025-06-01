import 'package:KafeKotaKita/Features/DetailCafe/controller/detailC_controller.dart';
import 'package:KafeKotaKita/service/api_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';
import 'package:KafeKotaKita/components/widget/custom_btnback.dart';


class DetailcScreen extends StatelessWidget {
  const DetailcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CafeDetailController controller = Get.put(CafeDetailController());

    return Scaffold(
      backgroundColor: black,
      body: Obx(() {
        if (controller.isLoading.value || controller.cafeData.value == null) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageGallery(controller),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCafeHeader(controller),
                    SizedBox(height: 24),
                    _buildInfoSection(controller),
                    SizedBox(height: 24),
                    _buildFacilitiesSection(controller),
                    SizedBox(height: 24),
                    _buildRatingSection(controller),
                    SizedBox(height: 24),
                    _buildGiveRatingSection(controller),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildImageGallery(CafeDetailController controller) {
    final mainGalleryList = controller.getMainGallery();

    return Stack(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: PageView.builder(
            itemCount: mainGalleryList.length,
            controller: PageController(viewportFraction: 0.95),
            itemBuilder: (context, index) {
              final item = mainGalleryList[index];
              final imageUrl = ApiConfig.storageImage(item.url ?? '');

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey,
                      child: Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 50,
          left: 20,
          child: CustomBackButton(),
        ),
      ],
    );
  }

  Widget _buildCafeHeader(CafeDetailController controller) {
    final cafe = controller.cafeData.value!;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cafe.nama ?? '-', style: AppTextStyles.h1(color: white)),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: 20),
                  SizedBox(width: 4),
                  Text(
                    (cafe.totalRating?.toStringAsFixed(1) ?? '0.0'),
                    style: AppTextStyles.bodyMedium(
                        color: white, weight: AppTextStyles.semiBold),
                  ),
                  SizedBox(width: 4),
                  Text('(rating)', style: AppTextStyles.bodyMedium(color: clrfont2)),
                ],
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: (cafe.genre ?? []).map<Widget>((genre) {
                  final name = genre.nama ?? '-';
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: clrfont3.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(name, style: AppTextStyles.bodySmall(color: white)),
                  );
                }).toList(),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        _buildBookmarkButton(controller),
      ],
    );
  }

  Widget _buildBookmarkButton(CafeDetailController controller) {
    return Obx(() => GestureDetector(
      onTap: controller.isTogglingBookmark.value ? null : controller.toggleBookmark,
      child: Opacity(
        opacity: controller.isTogglingBookmark.value ? 0.5 : 1.0,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: controller.isSaved.value 
                ? Colors.red.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            controller.isSaved.value ? Icons.bookmark_remove : Icons.bookmark_add,
            color: controller.isSaved.value ? Colors.red : Colors.green,
          ),
        ),
      ),
    ));
  }

  Widget _buildInfoSection(CafeDetailController controller) {
    final cafe = controller.cafeData.value!;
    
    return Column(
      children: [
        _buildInfoBox(Icons.location_on, cafe.alamat ?? '-'),
        SizedBox(height: 16),
        _buildInfoBox(Icons.access_time, 'Buka: ${cafe.jamBuka ?? '-'} - ${cafe.jamTutup ?? '-'}'),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () => _showMenuDialog(controller),
          child: _buildInfoBox(Icons.restaurant_menu, 'Menu', showArrow: true),
        ),
      ],
    );
  }

  Widget _buildInfoBox(IconData icon, String text, {bool showArrow = false}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: black, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(text, style: AppTextStyles.bodyMedium(color: black)),
          ),
          if (showArrow) Icon(Icons.keyboard_arrow_right, color: black, size: 20),
        ],
      ),
    );
  }

  Widget _buildFacilitiesSection(CafeDetailController controller) {
    final facilities = controller.cafeData.value?.fasilitas ?? [];

    if (facilities.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fasilitas', style: AppTextStyles.h3(color: white)),
        SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: facilities.map<Widget>((facility) {
            final String name = facility.nama ?? '-';
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: clrfont3.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(controller.getFacilityIcon(name), color: white, size: 20),
                  SizedBox(width: 8),
                  Text(name, style: AppTextStyles.bodyMedium(color: white)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingSection(CafeDetailController controller) {
    final cafe = controller.cafeData.value!;
    
    return Row(
      children: [
        Text(
          (cafe.totalRating?.toStringAsFixed(1) ?? '0.0'),
          style: AppTextStyles.h1(color: white),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(5, (_) => Icon(Icons.star, color: Colors.orange, size: 16)),
            ),
            SizedBox(height: 4),
            Text('(rating)', style: AppTextStyles.bodySmall(color: clrfont2)),
          ],
        ),
      ],
    );
  }

  Widget _buildGiveRatingSection(CafeDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Beri Rating', style: AppTextStyles.h3(color: white)),
        SizedBox(height: 16),
        Obx(() => Row(
          children: [
            SizedBox(width: 12),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => controller.setUserRating(index + 1),
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      controller.userRating.value > index ? Icons.star : Icons.star_border,
                      color: controller.userRating.value > index ? Colors.orange : clrfont2,
                      size: 24,
                    ),
                  ),
                );
              }),
            ),
            if (controller.userRating.value > 0) ...[
              SizedBox(width: 12),
              Text(
                '(${controller.userRating.value}/5)',
                style: AppTextStyles.bodyMedium(color: clrfont2),
              ),
            ]
          ],
        )),
        SizedBox(height: 16),
        Obx(() => controller.userRating.value > 0
            ? ElevatedButton(
                onPressed: controller.submitRating,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Kirim Rating", style: TextStyle(color: Colors.white)),
              )
            : SizedBox.shrink()),
      ],
    );
  }

  void _showMenuDialog(CafeDetailController controller) {
    final menuGalleryList = controller.getMenuGallery();

    if (menuGalleryList.isNotEmpty) {
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight * 0.6,
                  width: constraints.maxWidth,
                  child: PageView.builder(
                    itemCount: menuGalleryList.length,
                    controller: PageController(viewportFraction: 0.9),
                    itemBuilder: (context, index) {
                      final menuItem = menuGalleryList[index];
                      final imageUrl = ApiConfig.storageImage(menuItem.url ?? '');

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey,
                                child: Center(child: Icon(Icons.error)),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );
    } else {
      Get.snackbar('Info', 'Menu belum tersedia');
    }
  }
}