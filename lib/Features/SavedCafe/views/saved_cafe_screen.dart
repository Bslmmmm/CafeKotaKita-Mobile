import 'package:flutter/material.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import 'package:tugas_flutter/Features/SavedCafe/managers/list_saved.dart';
import '../../../components/widget/custom_btnback.dart';
import '../../../components/widget/custom_card_cafe.dart';
import 'package:tugas_flutter/Features/Homepage/model/model_homepage.dart';

class SavedCafeScreen extends StatefulWidget {
  const SavedCafeScreen({super.key});

  @override
  State<SavedCafeScreen> createState() => _SavedCafeScreenState();
}

class _SavedCafeScreenState extends State<SavedCafeScreen> {
  late bookmarklistmanager _bmListManager;

  List<CafeData>_displaybookmark=[];

@override
  void initState() {
    _bmListManager.loadbookmark();
    super.initState();
  }

@override
  void dispose() {
    _bmListManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: clrbg,
      body: Column(
        children: [

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
                        cafeimgurl: caf,
                        namacafe: cafe.,
                        lokasi: cafe,
                        jambuka: cafe.,
                        jamtutup: cafe,
                        rating: cafe.,
                        isOpen: cafe.,
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
