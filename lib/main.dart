import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes.dart';
import 'app/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Face Condition Detector',
      theme: ThemeData(
        primaryColor: AppThemes.primary,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.onboarding,
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}