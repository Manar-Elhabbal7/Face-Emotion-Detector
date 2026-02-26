import 'package:face_condition_detector/modules/onboarding/onboarding_controllor.dart';
import 'package:flutter/material.dart';
import '../../app/themes.dart';

class welcomePage extends StatelessWidget {
  final OnboardingController controller;

  const welcomePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Face Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppThemes.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.face,
                size: 80,
                color: AppThemes.primary,
              ),
            ),
            const SizedBox(height: 40),

            // Title
            const Text(
              'Mood Detector',
              style: AppThemes.heading1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Subtitle
            const Text(
              'Detect Your Face Mood & Analyze Lighting in Real-Time',
              style: AppThemes.body2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Features
            _buildFeatureRow(
              Icons.sentiment_satisfied,
              'Know Your Mood',
              'Happy, Sad, Tired or Stressed',
            ),
            const SizedBox(height: 20),
            _buildFeatureRow(
              Icons.light_mode,
              'Smart Lighting',
              'Works in any lighting condition',
            ),
            const SizedBox(height: 20),
            _buildFeatureRow(
              Icons.camera_alt,
              'Multiple Options',
              'Selfie, Back Camera or photo upload',
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppThemes.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
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
                style: AppThemes.body1.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: AppThemes.body2),
            ],
          ),
        ),
      ],
    );
  }
}
