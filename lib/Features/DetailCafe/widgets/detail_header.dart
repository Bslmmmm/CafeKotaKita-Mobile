import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailCafeHeader extends StatelessWidget {
int item;
  DetailCafeHeader({
    super.key,
    this.item = 3,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 220,
            child: CarouselView(
              itemExtent: double.infinity, 
              children: List.generate(item, (int index){
                return Container(
                  color: primaryc,
                );
              })
              )
              ),
        ],
      ),
    );
  }
}
