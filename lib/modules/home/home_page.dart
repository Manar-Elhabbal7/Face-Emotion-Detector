import 'package:face_condition_detector/modules/home/home_controllor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/themes.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());

  List<BottomNavigationBarItem> get items => const [
        BottomNavigationBarItem(
          icon: Icon(Icons.portrait),
          label: 'Selfie',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Back Camera',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.image),
          label: 'Upload',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Emotion Detection'),
        backgroundColor: AppThemes.appBarColor,
        elevation: 0,
      ),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: [
          buildScreen(Icons.portrait, "Selfie Screen"),
          buildScreen(Icons.camera_alt, "Back Camera Screen"),
          buildScreen(Icons.image, "Upload Screen"),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget buildScreen(IconData icon, String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: AppThemes.primary),
          const SizedBox(height: 32),
          Text(text, style: AppThemes.heading2),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
      () => BottomNavigationBar(
        items: items,
        currentIndex: controller.currIdx.value,
        selectedItemColor: AppThemes.primary,
        unselectedItemColor: Colors.grey,
        onTap: controller.changeIndex,
      ),
    );
  }
}
