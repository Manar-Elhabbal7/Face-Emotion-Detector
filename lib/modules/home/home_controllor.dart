import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  // Current bottom nav index
  var currentIndex = 0.obs;

  // PageController for swiping between screens
  final PageController pageController = PageController();

  // Called when bottom nav item is tapped
  void changeIndex(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index); // jump to the tapped page
  }

  // Called when page is swiped
  void onPageChanged(int index) {
    currentIndex.value = index; // update bottom nav
  }

  @override
  void onClose() {
    pageController.dispose(); // clean up when controller is destroyed
    super.onClose();
  }
}