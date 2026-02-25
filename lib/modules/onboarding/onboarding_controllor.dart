import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  var permissionsGranted = false.obs;

  void nextPage() {
    if (currentPage.value < 2) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  void skipToEnd() {
    currentPage.value = 2;
  }

  
  Future<void> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final photoStatus = await Permission.photos.request();

    permissionsGranted.value =
        cameraStatus.isGranted && photoStatus.isGranted;
  }
}