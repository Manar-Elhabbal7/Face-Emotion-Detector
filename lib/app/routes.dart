import 'package:face_condition_detector/modules/onboarding/onboarding.dart';
import 'package:face_condition_detector/modules/home/home_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String camera = '/camera';


  static final routes = [
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: home, page: () =>  HomePage()),
  ];
}