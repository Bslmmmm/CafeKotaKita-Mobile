import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import 'package:tugas_flutter/components/widget/custom_button.dart';
import 'package:tugas_flutter/components/widget/custom_searchbar.dart';

class HomepageTest extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  HomepageTest({super.key});

  void onSearch(String value){
    //logika search
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 160,
              color: primaryc,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomSearchbar(//masih bisa di resize*tanya arifin
                    controller: searchController,
                    onChanged: onSearch,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomHomeButton(
                        label: 'Nearest\nCafe', 
                        icon: Icons.location_on, 
                        onPressed: (){},
                        backgroundColor: white,
                        iconColor: primaryc,
                        textColor: primaryc,
                        ),
                        SizedBox(width: 10),
                      CustomHomeButton(
                        label: 'Top Cafe', 
                        icon: Icons.star_rounded, 
                        onPressed: (){},
                        backgroundColor: clrbtn,
                        iconColor: clrbg,
                        textColor: clrbg,
                        ),
                        SizedBox(width: 10),
                      CustomHomeButton(
                        label: 'Open', 
                        icon: Icons.watch_later_rounded, 
                        onPressed: (){},
                        backgroundColor: clrbtn,
                        iconColor: clrbg,
                        textColor: clrbg,
                        ),
                    ],
                  )
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Pick a cafe in your city',
              textAlign:TextAlign.left,
              style: AppTextStyles.poppinsBody(
                fontSize: 18,
                weight: AppTextStyles.semiBold,
                color: black
              ),
              ),
          )
          ],
        ),
      ),
    );
  }
}
