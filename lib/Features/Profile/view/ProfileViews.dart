import 'package:KafeKotaKita/Features/Profile/controller/profile_controller.dart';
import 'package:KafeKotaKita/Features/Profile/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';
import 'package:KafeKotaKita/routes/app_routes.dart';
import 'package:KafeKotaKita/components/widget/profile_list_tile.dart';
import 'package:KafeKotaKita/components/widget/widget_profile_card.dart';


class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController controller = ProfileController();

  @override
  Widget build(BuildContext context) {
    final UserModel? user = controller.getUser();

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "User data not found",
            style: AppTextStyles.interBody(color: primaryc),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: clrbg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Profile',
                      style: AppTextStyles.montserratBody(
                        fontSize: 24,
                        weight: AppTextStyles.bold,
                        color: primaryc,
                      )),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: user.profileImage.startsWith('http')
                          ? Image.network(
                              user.profileImage,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 80),
                            )
                          : Image.asset(
                              user.profileImage,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 80),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.username,
                              style: AppTextStyles.interBody(
                                  fontSize: 20, weight: AppTextStyles.bold, color: primaryc)),
                          Text(user.email,
                              style: AppTextStyles.interBody(
                                  fontSize: 14, weight: AppTextStyles.regular, color: primaryc)),
                          Text(user.phoneNumber,
                              style: AppTextStyles.interBody(
                                  fontSize: 14, weight: AppTextStyles.regular, color: primaryc)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ProfileCard(
                children: [
                  ProfileListTile(
                    icon: Icons.bookmark,
                    title: 'Saved Cafee',
                    onTap: () => Get.toNamed(AppRoutes.savedcafe),
                  ),
                ],
              ),
              ProfileCard(
                children: [
                  ProfileListTile(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    onTap: () => Get.toNamed(AppRoutes.editprofile),
                  ),
                  const ProfileDivider(),
                  ProfileListTile(
                    icon: Icons.lock_reset,
                    title: 'Reset Password',
                    onTap: () => Get.toNamed(AppRoutes.forgotpass),
                  ),
                  const ProfileDivider(),
                  ProfileListTile(
                    icon: Icons.logout,
                    title: 'Log Out',
                    onTap: () => _logout(context),
                  ),
                ],
              ),
              ProfileCard(
                children: [
                  ProfileListTile(
                    icon: Icons.info,
                    title: 'About Cafe Kota Kita',
                    onTap: () => Get.toNamed(AppRoutes.aboutcafe),
                  ),
                  const ProfileDivider(),
                  ProfileListTile(
                    icon: Icons.phone,
                    title: 'Contact Us',
                    onTap: () => Get.toNamed(AppRoutes.contactus),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: primaryc,
        title: Text("Logout", style: AppTextStyles.montserratH1(color: white)),
        content: Text("Apakah Anda yakin ingin keluar?",
            style: AppTextStyles.poppinsBody(color: clrfont2)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Batal",
                style: AppTextStyles.poppinsBody(color: white, weight: AppTextStyles.semiBold)),
          ),
          TextButton(
            onPressed: () {
              controller.logout();
              Get.offAllNamed(AppRoutes.login);
            },
            child: Text("Keluar",
                style: AppTextStyles.poppinsBody(color: white, weight: AppTextStyles.semiBold)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
