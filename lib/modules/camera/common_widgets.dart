import 'dart:io';
import 'package:face_condition_detector/app/themes.dart';
import 'package:face_condition_detector/modules/results/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:face_condition_detector/services/face_analyzer.dart';

//Fix Image
class SharedImageAnalyzer {
  static Future<File> fixImage(String path) async {
    try {
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        path,
        format: CompressFormat.jpeg,
        quality: 100,
        rotate: 0,
      );

      if (compressedBytes == null) return File(path);

      final tempFile =
          await File('${path}_fixed.jpg').writeAsBytes(compressedBytes);
      return tempFile;
    } catch (e) {
      print(' Image fix failed: $e');
      return File(path);
    }
  }

  //Analsis
  static Future<Result> analyzeFace(
    String imagePath,
    FaceDetectionService faceDetectionService,
  ) async {
    try {
      final result = await faceDetectionService.analyzeFaceFromImage(imagePath);
      return result;
    } catch (e) {
      return Result(
        success: false,
        message: 'Error analyzing face: $e',
      );
    }
  }

  //Result 
  static void showResultDialog({
    required BuildContext context,
    required Result result,
    required VoidCallback onRetakeOrChooseAnother,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: AppThemes.lightGrey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppThemes.primary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Analysis Complete',
                style: AppThemes.heading3,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildResultRowDialog(
                      'Mood',
                      MoodResult().formatMood(result.emotionalState),
                      AppThemes.primary,
                    ),
                    const Divider(height: 15),
                    _buildResultRowDialog(
                      'Lighting',
                      LightResult().formatLighting(result.lightingStatus),
                      AppThemes.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              //buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onRetakeOrChooseAnother();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppThemes.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Choose Another',
                        style: TextStyle(
                          color: AppThemes.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showErrorDialog({
    required BuildContext context,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  color: Colors.red.shade700,
                  size: 40,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Oops!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildResultRowDialog(
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
