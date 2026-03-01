import 'package:face_condition_detector/app/themes.dart';
import 'package:face_condition_detector/modules/results/result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:face_condition_detector/modules/results/result_controllor.dart';
import 'package:face_condition_detector/services/face_analyzer.dart';
import 'dart:io';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _imagePicker = ImagePicker();
  final ResultController _resultController = Get.put(ResultController());
  final FaceDetectionService _faceDetectionService = FaceDetectionService();

  XFile? _selectedImage;
  bool _isAnalyzing = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _faceDetectionService.init();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  Future<File> _fixImage(String path) async {
    try {
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        path,
        format: CompressFormat.jpeg,
        quality: 100,
        rotate: 0,
      );

      if (compressedBytes == null) return File(path);

      final tempFile = await File('${path}_fixed.jpg').writeAsBytes(compressedBytes);
      return tempFile;
    } catch (e) {
      print('Image fix failed: $e');
      return File(path);
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        final fixedFile = await _fixImage(image.path);
        setState(() {
          _selectedImage = XFile(fixedFile.path);
        });
        _animationController.forward();
        await _analyzeFace(fixedFile.path);
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image: $e');
    }
  }

  Future<void> _analyzeFace(String imagePath) async {
    setState(() => _isAnalyzing = true);

    try {
      final result = await _faceDetectionService.analyzeFaceFromImage(imagePath);
      _resultController.setResult(result);

      if (result.success) {
        _showResultDialog(result);
      } else {
        _showErrorDialog(result.message);
      }
    } catch (e) {
      _showErrorDialog('Error analyzing face: $e');
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  void _showResultDialog(Result result) {
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
              // 🎯 Success Icon
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
              // 📊 Results
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildResultRowDialog(
                      '😊 Mood',
                      MoodResult().formatMood(result.emotionalState),
                      AppThemes.primary,
                    ),
                    const Divider(height: 15),
                    _buildResultRowDialog(
                      '💡 Lighting',
                      LightResult().formatLighting(result.lightingStatus),
                      AppThemes.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 🔘 Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _selectedImage = null;
                        _animationController.reset();
                        setState(() {});
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

  void _showErrorDialog(String message) {
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

  Widget _buildResultRowDialog(String label, String value, Color color) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _selectedImage != null
                      ? ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.elasticOut,
                            ),
                          ),
                          child: Container(
                            height: 320,
                            width: 320,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppThemes.primary,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppThemes.primary.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                File(_selectedImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(30),
                              decoration: const BoxDecoration(
                                color: AppThemes.lightGrey,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.image,
                                size: 80,
                                color: Color.fromARGB(255, 135, 167, 216),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Choose a photo from your gallery',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 40),
                // 🔘 Action Button or Loading
                if (_isAnalyzing)
                  Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppThemes.primary),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Analyzing your face...',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Pick from Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _faceDetectionService.dispose();
    super.dispose();
  }
}