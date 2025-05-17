import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Constant/constants.dart';

class ResetPasswordImage extends StatelessWidget {
  const ResetPasswordImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "RESET PASSWORD",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding), // Dulu 2x, sekarang lebih rapat
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SvgPicture.asset("assets/icons/reset.svg"),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding), // Dulu 2x
        const Text(
          "Silakan masukkan password baru Anda untuk mengganti password lama.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(
            height: defaultPadding), // Bisa hapus kalau mau lebih rapat lagi
      ],
    );
  }
}
