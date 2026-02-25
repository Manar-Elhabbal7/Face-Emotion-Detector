import 'package:face_condition_app/modules/onboarding/onboarding_controllor.dart';
import 'package:flutter/material.dart';
import '../../app/themes.dart';


class permissionPage extends StatelessWidget {
  final OnboardingController controller;

  const permissionPage({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            
            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppThemes.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.security,
                size: 80,
                color: AppThemes.secondary,
              ),
            ),
            const SizedBox(height: 40),

            const Text(
              'Grant Permissions',
              style: AppThemes.heading1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            const Text(
              'We need access to camera and gallery',
              style: AppThemes.body2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            _buildPermissionItem(
              Icons.videocam,
              'Camera',
              'To capture photos',
            ),
            const SizedBox(height: 16),
            _buildPermissionItem(
              Icons.image,
              'Gallery',
              'To upload photos ',
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem(
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemes.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppThemes.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppThemes.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      AppThemes.body1.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(description, style: AppThemes.body2),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Color.fromARGB(255, 59, 118, 60),
            size: 28,
          ),
        ],
      ),
    );
  }
}