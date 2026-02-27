import 'dart:io';
import 'dart:ui' show Rect;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

// ─────────────────────────────────────────────
// Result Model
// ─────────────────────────────────────────────
class Result {
  final bool success;
  final String message;
  final String emotionalState;
  final String lightingStatus;
  final double smile;
  final double leftEyeOpen;
  final double rightEyeOpen;
  final double headEulerAngleX;
  final double headEulerAngleY;

  Result({
    required this.success,
    required this.message,
    this.emotionalState = 'Normal',
    this.lightingStatus = 'Unknown',
    this.smile = 0,
    this.leftEyeOpen = 0,
    this.rightEyeOpen = 0,
    this.headEulerAngleX = 0,
    this.headEulerAngleY = 0,
  });
}

// ─────────────────────────────────────────────
// Face Detection Service
// ─────────────────────────────────────────────
class FaceDetectionService {
  FaceDetector? _faceDetector;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // ✅ init بسيطة بدون tflite
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableLandmarks:      true,
          enableClassification: true,  // smile + eye open probability
          enableTracking:       true,
          minFaceSize:          0.1,
          performanceMode:      FaceDetectorMode.fast,
        ),
      );

      _isInitialized = true;
      print('✅ FaceDetectionService initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize FaceDetectionService: $e');
      rethrow;
    }
  }

  // ✅ تحليل الوجه من صورة
  Future<Result> analyzeFaceFromImage(String imagePath) async {
    if (!_isInitialized || _faceDetector == null) {
      return Result(
        success: false,
        message: 'Service not initialized. Call init() first.',
      );
    }

    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return Result(success: false, message: 'Image file not found');
      }

      final inputImage = InputImage.fromFilePath(imagePath);
      final faces      = await _faceDetector!.processImage(inputImage);

      if (faces.isEmpty) {
        return Result(success: false, message: 'No Face Found');
      }

      final face = faces.first;

      final smile           = face.smilingProbability       ?? 0.0;
      final leftEyeOpen     = face.leftEyeOpenProbability   ?? 0.0;
      final rightEyeOpen    = face.rightEyeOpenProbability  ?? 0.0;
      final headEulerAngleX = face.headEulerAngleX          ?? 0.0;
      final headEulerAngleY = face.headEulerAngleY          ?? 0.0;

      // ✅ تحليل المشاعر من ML Kit بدون tflite
      final emotionalState = _detectEmotionFromMLKit(
        smile:           smile,
        leftEyeOpen:     leftEyeOpen,
        rightEyeOpen:    rightEyeOpen,
        headEulerAngleY: headEulerAngleY,
        headEulerAngleZ: face.headEulerAngleZ ?? 0.0,
      );

      // ✅ تحليل الإضاءة من الصورة
      final imageBytes = await file.readAsBytes();
      final imageFile  = img.decodeImage(imageBytes);
      final lightingStatus = imageFile != null
          ? _analyzeLightingFaceOnly(imageFile, face.boundingBox)
          : 'Unknown';

      print('📊 Emotion: $emotionalState | Lighting: $lightingStatus');

      return Result(
        success:          true,
        message:          'Face Analyzed Successfully',
        emotionalState:   emotionalState,
        lightingStatus:   lightingStatus,
        smile:            smile,
        leftEyeOpen:      leftEyeOpen,
        rightEyeOpen:     rightEyeOpen,
        headEulerAngleX:  headEulerAngleX,
        headEulerAngleY:  headEulerAngleY,
      );
    } catch (e) {
      print('❌ Error analyzing face: $e');
      return Result(success: false, message: 'Error analyzing face: $e');
    }
  }

  // ─────────────────────────────────────────────
  // Emotion Logic — ML Kit فقط بدون tflite
  // ─────────────────────────────────────────────
  String _detectEmotionFromMLKit({
    required double smile,
    required double leftEyeOpen,
    required double rightEyeOpen,
    required double headEulerAngleY,
    required double headEulerAngleZ,
  }) {
    final avgEye = (leftEyeOpen + rightEyeOpen) / 2;

    // 😊 Happy — ابتسامة عالية
    if (smile > 0.7) return 'Happy';

    // 😴 Tired — العيون شبه مسكرة
    if (avgEye < 0.4) return 'Tired';

    // 😰 Stressed — الرأس متحرك كتير + مش بيبتسم
    if ((headEulerAngleY.abs() > 15 || headEulerAngleZ.abs() > 15) &&
        smile < 0.4) {
      return 'Stressed';
    }

    // 😔 Sad — مش بيبتسم والعيون مفتوحة
    if (smile < 0.2 && avgEye > 0.6) return 'Sad';

    // 😐 Neutral
    return 'Neutral';
  }

  // ─────────────────────────────────────────────
  // Lighting Analysis
  // ─────────────────────────────────────────────
  String _analyzeLightingFaceOnly(img.Image imageFile, Rect faceRect) {
    try {
      double totalBrightness = 0;
      int    sampleCount     = 0;

      final startX = faceRect.left.toInt().clamp(0,   imageFile.width  - 1);
      final startY = faceRect.top.toInt().clamp(0,    imageFile.height - 1);
      final endX   = faceRect.right.toInt().clamp(0,  imageFile.width);
      final endY   = faceRect.bottom.toInt().clamp(0, imageFile.height);

      final stepX = ((endX - startX) ~/ 20).clamp(1, 10);
      final stepY = ((endY - startY) ~/ 20).clamp(1, 10);

      for (int y = startY; y < endY; y += stepY) {
        for (int x = startX; x < endX; x += stepX) {
          final pixel = imageFile.getPixel(x, y);
          final r = pixel.r.toDouble();
          final g = pixel.g.toDouble();
          final b = pixel.b.toDouble();
          final brightness = (0.299 * r + 0.587 * g + 0.114 * b) / 255.0;
          totalBrightness += brightness;
          sampleCount++;
        }
      }

      if (sampleCount == 0) return 'Unknown';
      final avgBrightness = totalBrightness / sampleCount;

      if (avgBrightness > 0.75) return 'Too Bright';
      if (avgBrightness > 0.6)  return 'Bright';
      if (avgBrightness > 0.4)  return 'Good Lighting';
      if (avgBrightness > 0.25) return 'Dim';
      return 'Too Dark';
    } catch (e) {
      print('❌ Error in lighting analysis: $e');
      return 'Could not analyze lighting';
    }
  }

  void dispose() {
    _faceDetector?.close();
    _isInitialized = false;
    print('✅ FaceDetectionService disposed');
  }
}