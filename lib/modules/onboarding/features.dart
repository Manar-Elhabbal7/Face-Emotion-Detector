import 'package:face_condition_app/modules/onboarding/onboarding_controllor.dart';
import 'package:flutter/material.dart';
import '../../app/themes.dart';

class FeaturesPage extends StatelessWidget {
  final OnboardingController controller;

  const FeaturesPage({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            const Text(
              'How to use it?',
              style: AppThemes.heading1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            _buildStep(
              number: '1',
              title: 'Choose Source',
              description:
                  'Take a photo (selfie/back) or upload from gallery',
              icon: Icons.photo_camera,
            ),
            const SizedBox(height: 24),
            _buildStep(
              number: '2',
              title: 'Detect Your Emotion',
              description:
                  'Our App will detect your mood & analyze lighting conditions',
              icon: Icons.face_retouching_natural,
            ),
            const SizedBox(height: 24),
            _buildStep(
              number: '3',
              title: 'Get Results',
              description:
                  'View detailed insights about your mood & condition',
              icon: Icons.analytics,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemes.lightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: AppThemes.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
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
                const SizedBox(height: 6),
                Text(description, style: AppThemes.body2),
              ],
            ),
          ),
          Icon(icon, color: AppThemes.primary, size: 32),
        ],
      ),
    );
  }
}