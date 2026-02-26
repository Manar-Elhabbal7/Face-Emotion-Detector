import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  var currIdx = 0.obs;
  final PageController pageController = PageController();

  void changeIndex(int index) {
    currIdx.value = index;
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    currIdx.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
