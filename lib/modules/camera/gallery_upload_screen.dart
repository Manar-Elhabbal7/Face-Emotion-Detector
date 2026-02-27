import 'package:face_condition_detector/modules/results/result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:face_condition_detector/modules/results/result_controllor.dart';
import 'package:face_condition_detector/services/face_analyzer.dart';
import 'dart:io';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final ResultController _resultController = Get.put(ResultController());
  final FaceDetectionService _faceDetectionService = FaceDetectionService();

  XFile? _selectedImage;
  bool _isAnalyzing = false;

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
        await _analyzeFace(image.path);
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image: $e');
    }
  }

  Future<void> _analyzeFace(String imagePath) async {
    setState(() => _isAnalyzing = true);

    try {
      final result =
          await _faceDetectionService.analyzeFaceFromImage(imagePath);
      _resultController.setResult(result  );

      if (result.success) {
        _showResultDialog(result );
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
             _buildResultRow('Mood', MoodResult().formatMood(result.emotionalState)),
             const SizedBox(height: 10),
              _buildResultRow('Lighting', LightResult().formatLighting(result.lightingStatus)),
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
              _selectedImage = null;
              setState(() {});
            },
            child: const Text('Choose Another'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedImage != null)
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.orange, width: 3),
                ),
                child: Image.file(
                  File(_selectedImage!.path),
                  fit: BoxFit.cover,
                ),
              )
            else
              const SizedBox(height: 30),
            if (_isAnalyzing)
              const CircularProgressIndicator()
            else
              InkWell(
                onTap: _pickImageFromGallery,
                child: Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.grey[400],
                ),
              ),
          ],
        ),
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
          style: const TextStyle(fontSize: 14, color: Colors.orange),
        ),
      ],
    );
  }
}
