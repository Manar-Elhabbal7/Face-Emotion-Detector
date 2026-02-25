import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  var permissionsGranted = false.obs;

  final PageController pageController = PageController();

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToEnd() {
    pageController.jumpToPage(2);
  }

  Future<void> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final photoStatus = await Permission.photos.request();

    permissionsGranted.value =
        cameraStatus.isGranted && photoStatus.isGranted;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}