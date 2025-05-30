import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';
import 'package:KafeKotaKita/components/widget/custom_btnback.dart';
import 'package:flutter/material.dart';

class AboutCafePage extends StatelessWidget {
  const AboutCafePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrbg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const CustomBackButton(),
              const SizedBox(height: 5),

              // Text "about"
              Center(
                child: Text(
                  "about",
                  style: AppTextStyles.montserratBody(
                    color: primaryc,
                    weight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Gambar di tengah
              Center(
                child: Image.asset(
                  'assets/images/icon4.png',
                  width: 80,
                  height: 80,
                ),
              ),

              const SizedBox(height: 12),

              // Text "kafe kota kita"
              Center(
                child: Text(
                  "kafe kota kita",
                  style: AppTextStyles.montserratBody(
                    color: primaryc,
                    weight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              Center(
                child: Text(
                  "version 1.0.0",
                  style: AppTextStyles.poppinsBody(
                    color: clrfont2,
                    weight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  color: primaryc,
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tentang Aplikasi Section
                    Text(
                      "Tentang Aplikasi",
                      style: AppTextStyles.montserratBody(
                        color: white,
                        weight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Cafe Kota Kita adalah aplikasi rekomendasi kafe berbasis Android dan website yang dikembangkan khusus untuk membantu masyarakat Kota Jember menemukan kafe sesuai dengan preferensi mereka.\n\nAplikasi ini hadir sebagai solusi atas kesulitan masyarakat dalam mencari informasi lengkap tentang kafe di Jember, mulai dari suasana, fasilitas, hingga event yang sedang berlangsung.",
                      style: AppTextStyles.poppinsBody(
                        color: white,
                        weight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Container(
                      height: 1,
                      color: white.withOpacity(0.2),
                    ),
                    const SizedBox(height: 24),

                    // Tim Pengembangan Section
                    Text(
                      "Tim Pengembangan",
                      style: AppTextStyles.montserratBody(
                        color: white,
                        weight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "A. Ilham Bintang E. - Ketua Kelompok & Mobile Developer\n"
                      "Dagi Rizki Ardiansyah - Mobile Developer & UI/UX Designer\n"
                      "Ariel Rezka Chandra - Mobile Developer & UI/UX Designer\n"
                      "Ali - Web Developer\n"
                      "Louis Hessel John - Web Developer & Database Engineer",
                      style: AppTextStyles.poppinsBody(
                        color: white,
                        weight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Container(
                      height: 1,
                      color: white.withOpacity(0.2),
                    ),
                    const SizedBox(height: 24),

                    // Informasi Kontak Section
                    Text(
                      "Informasi Kontak",
                      style: AppTextStyles.montserratBody(
                        color: white,
                        weight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Program Studi Teknik Informatika\n"
                      "Jurusan Teknologi Informasi\n"
                      "Politeknik Negeri Jember\n"
                      "Tahun Pengembangan: 2025",
                      style: AppTextStyles.poppinsBody(
                        color: white,
                        weight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
