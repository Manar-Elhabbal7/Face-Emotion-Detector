import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:face_condition_detector/modules/results/result.dart';
import 'package:face_condition_detector/modules/results/result_controllor.dart';
import 'package:face_condition_detector/services/face_analyzer.dart';

class SelfieScreen extends StatefulWidget {
  const SelfieScreen({super.key});

  @override
  State<SelfieScreen> createState() => _SelfieScreenState();
}

class _SelfieScreenState extends State<SelfieScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final ResultController _resultController = Get.put(ResultController());
  final FaceDetectionService _faceDetectionService = FaceDetectionService();

  XFile? _capturedImage;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    // Initialize FaceDetectionService
    _faceDetectionService.init();
  }
Future<void> _takeSelfie() async {
  if (!_faceDetectionService.isInitialized) {
    _showErrorDialog('Face Detection Service is not ready yet. Please wait.');
    return;
  }

  try {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 100,
    );

    if (image != null) {
      final fixedFile = await _fixImage(image.path);
      setState(() => _capturedImage = XFile(fixedFile.path));
      await _analyzeFace(fixedFile.path);
    }
  } catch (e) {
    _showErrorDialog('Failed to take selfie: $e');
  }
}

  /// Fix image rotation and convert HEIC/HEIF to JPEG if needed
  Future<File> _fixImage(String path) async {
    try {
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        path,
        format: CompressFormat.jpeg,
        quality: 100,
        rotate: 0, // auto rotation works
      );

      if (compressedBytes == null) return File(path);

      final tempFile = await File('${path}_fixed.jpg').writeAsBytes(compressedBytes);
      return tempFile;
    } catch (e) {
      print('⚠️ Image fix failed: $e');
      return File(path); // fallback
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
      builder: (context) => AlertDialog(
        title: const Text('Analysis Result'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildResultRow('Mood', result.emotionalState),
              const SizedBox(height: 10),
              _buildResultRow('Lighting', result.lightingStatus),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _capturedImage = null;
              setState(() {});
            },
            child: const Text('Retake'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.blue),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_capturedImage != null)
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue, width: 3),
                ),
                child: Image.file(
                  File(_capturedImage!.path),
                  fit: BoxFit.cover,
                ),
              )
            else
              const SizedBox(height: 30),
            const SizedBox(height: 20),
            if (_isAnalyzing)
              const CircularProgressIndicator()
            else
              InkWell(
                onTap: _takeSelfie,
                child: Icon(
                  Icons.portrait,
                  size: 100,
                  color: Colors.grey[400],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _faceDetectionService.dispose();
    super.dispose();
  }
}