import 'package:face_condition_detector/services/face_analyzer.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  var currIdx = 0.obs;
  var isServiceReady = false.obs;
  var isAnalyzing = false.obs;
  var result = Rxn<Result>();

  final PageController pageController = PageController();
  final FaceDetectionService _service = FaceDetectionService();

  @override
  void onInit() {
    super.onInit();
    _initService();
  }

  Future<void> _initService() async {
    try {
      await _service.init();
      isServiceReady.value = true;
      print(' FaceDetectionService is Ready!');
    } catch (e) {
      isServiceReady.value = false;
      print(' Failed to initialize service: $e');
    }
  }

  Future<void> analyzeImage(String imagePath) async {
    if (!isServiceReady.value) {
      print(' Service not ready yet!');
      return;
    }

    isAnalyzing.value = true;

    try {
      final analysisResult = await _service.analyzeFaceFromImage(imagePath);
      result.value = analysisResult;
      print(
          ' Done: ${analysisResult.emotionalState} | ${analysisResult.lightingStatus}');
    } catch (e) {
      print(' Error: $e');
      result.value = Result(success: false, message: 'Error: $e');
    } finally {
      isAnalyzing.value = false;
    }
  }

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
    _service.dispose();
    super.onClose();
  }
}
