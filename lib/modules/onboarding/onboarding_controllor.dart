import 'package:face_condition_detector/app/routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  var currPage = 0.obs;
  var permissionsGranted = false.obs;
  late SharedPreferences _prefs;

  final PageController pageController = PageController();

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
  }

  void onPageChanged(int index) {
    currPage.value = index;
  }

  void nextPage() {
    if (currPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currPage.value > 0) {
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

    permissionsGranted.value = cameraStatus.isGranted && photoStatus.isGranted;
  }
  Future<void> completeOnboarding() async {
    await _prefs.setBool('onboarding_completed', true);
    Get.offAllNamed(AppRoutes.home);
  }
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
