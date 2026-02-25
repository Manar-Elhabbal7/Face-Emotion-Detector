import 'package:face_condition_app/modules/home/home_controllor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/themes.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Analyzer'),
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.face, size: 100, color: AppThemes.primary),
            SizedBox(height: 32),

           Text(
              'Ready to Analyze?',
              style: AppThemes.heading2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),

           Text(
              'Choose how you want to capture your face',
              style: AppThemes.body2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 48),

           
          ],
        ),
      ),
    );
  }
}