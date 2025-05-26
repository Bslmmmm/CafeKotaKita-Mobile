import 'package:flutter/material.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import '../../../components/widget/custom_btnback.dart';
import '../../../components/widget/custom_card_cafe.dart';

class SavedCafeScreen extends StatelessWidget {
  const SavedCafeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ubah data cafe menjadi kosong untuk menampilkan empty state
    final List<Map<String, dynamic>> savedCafes = []; // <- kosong

    return Scaffold(
      backgroundColor: clrbg,
      body: Column(
        children: [
          // Header dengan back button dan title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: const CustomBackButton(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: primaryc,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Saved Cafee',
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
          ),
      
          // List cafe atau empty state
          Expanded(
            child: savedCafes.isNotEmpty
                ? ListView.builder(
                    itemCount: savedCafes.length,
                    itemBuilder: (context, index) {
                      final cafe = savedCafes[index];
                      return CustomCardCafe(
                        cafeimgurl: cafe['cafeimgurl'],
                        namacafe: cafe['namacafe'],
                        lokasi: cafe['lokasi'],
                        operationalhour: cafe['operationalhour'],
                        rating: cafe['rating'],
                        isOpen: cafe['isOpen'],
                        onTap: () {
                          print('Tapped on ${cafe['namacafe']}');
                        },
                      );
                    },
                  )
                : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  // Widget untuk state kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: primaryc,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.bookmark_outline,
              color: white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Tambahkan Cafe Baru',
            style: AppTextStyles.poppinsBody(
              color: primaryc,
              fontSize: 16,
              weight: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}
