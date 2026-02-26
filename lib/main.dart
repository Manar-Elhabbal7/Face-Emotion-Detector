import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes.dart';
import 'app/themes.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  runApp(const faceMood());
}

class faceMood extends StatelessWidget {
  const faceMood({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face Condition Detector',
      theme: ThemeData(
        primaryColor: AppThemes.primary,
        useMaterial3: true,
      ),

      initialRoute: AppRoutes.onboarding,
      getPages: AppRoutes.routes,
    );
  }
}