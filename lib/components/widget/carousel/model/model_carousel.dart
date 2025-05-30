import 'package:flutter/material.dart';

class CarouselItemData {
  final String imgUrl;
  final VoidCallback? onTap;

  const CarouselItemData({
    required this.imgUrl,
    this.onTap, 
  });


  CarouselItemData copyWith({String? imgUrl, VoidCallback? onTap}) {
    return CarouselItemData(
      imgUrl: imgUrl ?? this.imgUrl,
      onTap: onTap ?? this.onTap,
    );
  }
}
