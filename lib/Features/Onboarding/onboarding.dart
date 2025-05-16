import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
// import 'package:tugas_flutter/components/circleborder.dart';
import 'package:get/get.dart';
import 'package:tugas_flutter/Screens/Login/login_screen.dart';

class onboardingPage extends StatefulWidget {
  const onboardingPage({super.key});

  @override
  State<onboardingPage> createState() => _onboardingPageState();
}

class _onboardingPageState extends State<onboardingPage> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: PageView.builder(
              itemCount: demo_data.length,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) => Onboardingcontent(
                image: demo_data[index].image,
                nama: demo_data[index].nama,
                kata: demo_data[index].kata,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: _currentPage == demo_data.length - 1
                ? SizedBox(
                    width: 240,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offAll(LoginScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0B0B0C),
                        shape: StadiumBorder(),
                      ),
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        _pageController.nextPage(
                            curve: Curves.ease,
                            duration: const Duration(milliseconds: 700));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Color(0xFF0B0B0C),
                      ),
                      child: SvgPicture.asset(
                        'assets/Icons/Arrowk.svg',
                        colorFilter:
                            ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
          )
        ]),
      ),
    );
  }
}

class Onboard {
  final String image, nama, kata;

  Onboard({required this.image, required this.nama, required this.kata});
}

final List<Onboard> demo_data = [
  Onboard(
    image: 'ilustrasi/ob1.png',
    nama: 'Kafe Kota Kita',
    kata: 'Cari Kafe Berdasarkan Vibes',
  ),
  Onboard(
    image: 'ilustrasi/ob2.png',
    nama: 'Kafe Kota Kita',
    kata: 'Pasarkan Kafemu Secara Gratis',
  ),
  Onboard(
    image: 'ilustrasi/ob3.png',
    nama: 'Kafe Kota Kita',
    kata: 'Temukan Tempat Ngopi',
  ),
];

class Onboardingcontent extends StatelessWidget {
  const Onboardingcontent({
    super.key,
    required this.image,
    required this.nama,
    required this.kata,
  });

  final String image, nama, kata;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset(
          image,
          height: 264,
        ),
        SizedBox(height: 28),
        Text(
          nama,
          textAlign: TextAlign.center,
          style: AppTextStyles.poppinsBody(
              fontSize: 40,
              weight: AppTextStyles.extrabold,
              color: Colors.black),
        ),
        Text(
          kata,
          textAlign: TextAlign.center,
          style: AppTextStyles.poppinsBody(
              fontSize: 18, weight: AppTextStyles.medium, color: Colors.black),
        ),
        const Spacer()
      ],
    );
  }
}
