import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tugas_flutter/routes/app_routes.dart';
import '../controller/onboarding_controller.dart';
import 'onboarding_content.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingController(),
      child: Consumer<OnboardingController>(
        builder: (context, controller, _) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: controller.pageController,
                      itemCount: controller.demoData.length,
                      onPageChanged: controller.onPageChanged,
                      itemBuilder: (context, index) {
                        final item = controller.demoData[index];
                        return OnboardingContent(
                          image: item.image,
                          title: item.title,
                          subtitle: item.subtitle,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child:
                        controller.currentPage == controller.demoData.length - 1
                            ? SizedBox(
                                width: 240,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.offAllNamed(AppRoutes.login);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: StadiumBorder(),
                                  ),
                                  child: const Text(
                                    'Get Started',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: 60,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: controller.nextPage,
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor: Colors.black,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/Icons/Arrowk.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                              ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.demoData.length,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: controller.currentPage == i ? 12 : 8,
                        height: controller.currentPage == i ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == controller.currentPage
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
