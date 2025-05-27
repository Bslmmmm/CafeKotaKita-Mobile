import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import 'package:tugas_flutter/Features/Profile/controller/profile_controller.dart';
import 'package:tugas_flutter/components/widget/profile_list_tile.dart';
import 'package:tugas_flutter/components/widget/widget_profile_card.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Memuat data profil saat halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrbg,
      body: SafeArea(
        child: Consumer<ProfileController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.error.isNotEmpty) {
              return Center(
                child: Text(
                  'Error: ${controller.error}',
                  style:  AppTextStyles.interBody(
                    color: white,
                    fontSize: 20,
                    weight: AppTextStyles.bold
                    ),
                ),
              );
            }

            final user = controller.user;
            if (user == null) {
              return const Center(child: Text('No user data found'));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button dan Title
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                          Text(
                          'Profil Saya',
                          style: AppTextStyles.montserratBody(
                            fontSize: 24,
                            weight: AppTextStyles.bold,
                            color: primaryc
                            ),
                        ),
                      ],
                    ),
                  ),

                  // Profile Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        // Profile Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.asset(
                            user.profileImage,
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 50.0,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.username,
                                style:  AppTextStyles.interBody(
                                  fontSize: 20.0,
                                  weight: AppTextStyles.bold,
                                  color: primaryc
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                user.email,
                                style: AppTextStyles.interBody(
                                  fontSize: 14.0,
                                  weight: AppTextStyles.regular,
                                  color: primaryc,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                user.phoneNumber,
                                  style: AppTextStyles.interBody(
                                  fontSize: 14.0,
                                  weight: AppTextStyles.regular,
                                  color: primaryc,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // Saved Cafee Card
                  ProfileCard(
                    children: [
                      ProfileListTile(
                        icon: Icons.bookmark,
                        title: 'Saved Cafee',
                        onTap: () => controller.navigateToSavedCafes(context),
                      ),
                    ],
                  ),

                  // Account Settings Card
                  ProfileCard(
                    children: [
                      ProfileListTile(
                        icon: Icons.edit,
                        title: 'Edit Profile',
                        onTap: () => controller.navigateToEditProfile(context),
                      ),
                      const ProfileDivider(),
                      ProfileListTile(
                        icon: Icons.delete,
                        title: 'Delete Account',
                        onTap: () => controller.deleteAccount(context),
                      ),
                      const ProfileDivider(),
                      ProfileListTile(
                        icon: Icons.logout,
                        title: 'Log Out',
                        onTap: () => controller.logout(context),
                      ),
                    ],
                  ),

                  // About & Contact Card
                  ProfileCard(
                    children: [
                      ProfileListTile(
                        icon: Icons.info,
                        title: 'About Cafe Kota Kita',
                        onTap: () => controller.navigateToAboutCafe(context),
                      ),
                      const ProfileDivider(),
                      ProfileListTile(
                        icon: Icons.phone,
                        title: 'Contact Us',
                        onTap: () => controller.navigateToContactUs(context),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}