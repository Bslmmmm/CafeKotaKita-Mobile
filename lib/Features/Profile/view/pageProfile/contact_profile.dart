import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';
import 'package:KafeKotaKita/components/widget/custom_btnback.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrbg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const CustomBackButton(),
            const SizedBox(height: 5),
            Center(
              child: Text(
                "Contact Us",
                style: AppTextStyles.montserratBody(
                  color: primaryc,
                  weight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Hubungi Kami Box (satu-satunya)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: primaryc,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hubungi Kami",
                      style: AppTextStyles.montserratBody(
                        color: white,
                        weight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),
              
                    _buildContactItem("Email", "support@kafekotakita.com"),
                    const SizedBox(height: 16),
                    _buildContactItem("WhatsApp", "+62 857-4869-5683"),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      "Alamat",
                      "Politeknik Negeri Jember\nJl. Mastrip No. 164, Jember",
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem("Website", "www.kafekotakita.com"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.montserratBody(
            color: white,
            fontSize: 16,
            weight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: AppTextStyles.poppinsBody(
            color: white,
            fontSize: 14,
            weight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
