import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Constant/constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;

  const SignUpScreenTopImage({
    Key? key,
    this.imageWidth = 400, // default width
    this.imageHeight = 400, // default height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign Up".toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding),
        SvgPicture.asset(
          "assets/icons/signup.svg",
          width: imageWidth,
          height: imageHeight,
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
