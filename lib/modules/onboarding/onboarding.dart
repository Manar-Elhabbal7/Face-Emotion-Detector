import 'package:face_condition_app/modules/onboarding/features.dart';
import 'package:face_condition_app/modules/onboarding/onboarding_controllor.dart';
import 'package:face_condition_app/modules/onboarding/permissions.dart';
import 'package:face_condition_app/modules/onboarding/welcome_page.dart';
import 'package:face_condition_app/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes.dart';
import '../../app/themes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    final List<Widget> pages = [
      welcomePage(controller: controller),
      FeaturesPage(controller: controller),
      permissionPage(controller: controller),
    ];

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: controller.skipToEnd,
                    child: Text(
                      'Skip',
                      style: AppThemes.body1.copyWith(
                        color: AppThemes.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              
              Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: pages,
              ),
            ),

              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (index) => Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: controller.currentPage.value == index
                            ? AppThemes.primary
                            : AppThemes.primary.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  children: [
                    // Back Button
                    if (controller.currentPage.value > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.previousPage,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppThemes.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Back',
                            style: AppThemes.body1.copyWith(
                              color: AppThemes.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    if (controller.currentPage.value > 0)
                      const SizedBox(width: 12),

                    Expanded(
                      child: CustomButton(
                        label: controller.currentPage.value == pages.length - 1
                            ? 'start'
                            : 'Next',
                        onPressed: () async {
                          if (controller.currentPage.value == pages.length - 1) {
                            // Request permissions on last page
                            await controller.requestPermissions();
                            Get.offNamed(AppRoutes.home);
                          } else {
                            controller.nextPage();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}