import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes.dart';
import 'app/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isOnboardingComplete = prefs.getBool('onboarding_completed') ?? false;

  runApp(
    faceMood(
      initialRoute:
          isOnboardingComplete ? AppRoutes.home : AppRoutes.onboarding,
    ),
  );
}

class faceMood extends StatelessWidget {
  final String initialRoute;

  const faceMood({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Face Condition Detector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppThemes.primary, useMaterial3: true),
      initialRoute: initialRoute,
      getPages: AppRoutes.routes,
    );
  }
}
/*
//TODO: add shared preferences (done)
TODO: add guidence on using tabs (optional)
TODO: add ML support 
TODO : give results of mood and light 
TODO:Make repo and demo video 
TODO: insert perfect description in my proposal

 */