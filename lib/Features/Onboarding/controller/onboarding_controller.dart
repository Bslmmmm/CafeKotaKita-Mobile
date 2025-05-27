// lib/features/onboarding/controller/onboarding_controller.dart
import 'package:flutter/material.dart';
import 'package:tugas_flutter/Features/Onboarding/model/onboard_model.dart';

class OnboardingController extends ChangeNotifier {
  final PageController pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  int get currentPage => _currentPage;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < _demoData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 700),
        curve: Curves.ease,
      );
    }
  }

  static final List<Onboard> _demoData = [
    Onboard(
      image: 'assets/ilustrasi/ob1.png',
      title: 'Kafe Kota Kita',
      subtitle: 'Cari Kafe Berdasarkan Vibes',
    ),
    Onboard(
      image: 'assets/ilustrasi/ob2.png',
      title: 'Kafe Kota Kita',
      subtitle: 'Pasarkan Kafemu Secara Gratis',
    ),
    Onboard(
      image: 'assets/ilustrasi/ob3.png',
      title: 'Kafe Kota Kita',
      subtitle: 'Temukan Tempat Ngopi',
    ),
  ];

  List<Onboard> get demoData => _demoData;
}
