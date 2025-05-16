import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/text_strings.dart';
import 'package:tugas_flutter/Constant/size.dart';
import 'package:tugas_flutter/Constant/images.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                        image: AssetImage(tProfileImage2),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: primaryc,
                      ),
                      child: const Icon(
                        LineAwesomeIcons.camera_solid,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                  child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text(tFullName),
                      prefixIcon: Icon(LineAwesomeIcons.user),
                    ),
                  ),
                  const SizedBox(height: tFromHeight - 20),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text(tEmail),
                      prefixIcon: Icon(LineAwesomeIcons.envelope),
                    ),
                  ),
                  const SizedBox(height: tFromHeight - 20),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text(tPhone),
                      prefixIcon: Icon(LineAwesomeIcons.phone_alt_solid),
                    ),
                  ),
                  const SizedBox(height: tFromHeight),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () =>
                          Get.to(() => const UpdateProfileScreen()),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryc,
                          side: BorderSide.none,
                          shape: const StadiumBorder()),
                      child: const Text(tEditProfile,
                          style: TextStyle(color: Colors.black)),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
