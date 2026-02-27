import 'package:face_condition_detector/modules/camera/gallery_upload_screen.dart';
import 'package:face_condition_detector/modules/camera/take_photo.dart';
import 'package:face_condition_detector/modules/home/home_controllor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/themes.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());

  List<BottomNavigationBarItem> get items => const [
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Take Photo',
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
        children: const [
             SelfieScreen(),
             GalleryScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
