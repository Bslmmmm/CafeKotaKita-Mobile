// lib/Features/SavedCafe/screen/saved_cafe_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Features/SavedCafe/controller/saved_cafeC.dart';
import 'package:KafeKotaKita/Features/SavedCafe/widget/saved_cafe_header.dart';
import 'package:KafeKotaKita/Features/SavedCafe/widget/saved_cafe_list.dart';
import 'package:KafeKotaKita/Features/SavedCafe/widget/saved_cafe_emptystate.dart';

class SavedCafeScreen extends StatefulWidget {
  const SavedCafeScreen({super.key});

  @override
  State<SavedCafeScreen> createState() => _SavedCafeScreenState();
}

class _SavedCafeScreenState extends State<SavedCafeScreen> {
  late SavedCafeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SavedCafeController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadSavedCafes();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: white,
        body: Column(
          children: [
            const SavedCafeHeader(),
            Expanded(
              child: Consumer<SavedCafeController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (controller.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(controller.errorMessage!),
                          ElevatedButton(
                            onPressed: controller.loadSavedCafes,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (!controller.hasCafes) {
                    return const SavedCafeEmptyState();
                  }
                  
                  return SavedCafeList(
                    cafes: controller.savedCafes,
                    onRefresh: controller.refreshSavedCafes,
                    onCafeTap: (cafe) {
                      // Handle cafe tap - navigate to detail
                      print('Navigate to cafe detail: ${cafe.cafename}');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}