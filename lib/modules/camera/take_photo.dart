import 'dart:io';
import 'package:face_condition_detector/app/themes.dart';
import 'package:face_condition_detector/modules/camera/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:face_condition_detector/modules/results/result_controllor.dart';
import 'package:face_condition_detector/services/face_analyzer.dart';

class takePhoto extends StatefulWidget {
  const takePhoto({super.key});

  @override
  State<takePhoto> createState() => _takePhotoState();
}

class _takePhotoState extends State<takePhoto>
    with SingleTickerProviderStateMixin {
  final ImagePicker _imagePicker = ImagePicker();
  final ResultController _resultController = Get.put(ResultController());
  final FaceDetectionService _faceDetectionService = FaceDetectionService();

  XFile? _capturedImage;
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

  Future<void> _takeSelfie() async {
    if (!_faceDetectionService.isInitialized) {
      SharedImageAnalyzer.showErrorDialog(
        context: context,
        message: 'Face Detection Service is not ready yet. Please wait.',
      );
      return;
    }

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 100,
      );

      if (image != null) {
        final fixedFile = await SharedImageAnalyzer.fixImage(image.path);
        setState(() => _capturedImage = XFile(fixedFile.path));
        _animationController.forward();
        await _analyzeFace(fixedFile.path);
      }
    } catch (e) {
      SharedImageAnalyzer.showErrorDialog(
        context: context,
        message: 'Failed to take selfie: $e',
      );
    }
  }

  Future<void> _analyzeFace(String imagePath) async {
    setState(() => _isAnalyzing = true);

    try {
      final result = await SharedImageAnalyzer.analyzeFace(
        imagePath,
        _faceDetectionService,
      );
      _resultController.setResult(result);

      if (result.success) {
        SharedImageAnalyzer.showResultDialog(
          context: context,
          result: result,
          onRetakeOrChooseAnother: () {
            _capturedImage = null;
            _animationController.reset();
            setState(() {});
          },
        );
      } else {
        SharedImageAnalyzer.showErrorDialog(
          context: context,
          message: result.message,
        );
      }
    } catch (e) {
      SharedImageAnalyzer.showErrorDialog(
        context: context,
        message: 'Error analyzing face: $e',
      );
    } finally {
      setState(() => _isAnalyzing = false);
    }
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
                  child: _capturedImage != null
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
                                color: AppThemes.lightGrey,
                                width: 4,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppThemes.lightGrey,
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                File(_capturedImage!.path),
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
                                Icons.portrait,
                                size: 80,
                                color: Color.fromARGB(255, 136, 164, 208),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Ready to capture your selfie?',
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
                    onPressed: _takeSelfie,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Selfie'),
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
