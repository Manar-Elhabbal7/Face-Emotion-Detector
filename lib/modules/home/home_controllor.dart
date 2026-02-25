import 'package:get/get.dart';
import '../../app/routes.dart';

class HomeController extends GetxController {
  void openSelfieCamera() {
    // TODO: Open front camera
    Get.toNamed(AppRoutes.camera, arguments: {'isSelfie': true});
  }

  void openBackCamera() {
    // TODO: Open back camera
    Get.toNamed(AppRoutes.camera, arguments: {'isSelfie': false});
  }

  void uploadPhoto() {
    // TODO: Open gallery
  }
}