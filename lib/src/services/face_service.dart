// lib/services/face_service.dart
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yure_kyc_light/src/extension/extension.dart';

class FaceService {
  final FaceDetector _faceDetector;
  bool _isBusy = false;
  int _stableFrames = 0;

  FaceService()
    : _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableContours: true,
          enableClassification: true,
          performanceMode: FaceDetectorMode.accurate,
        ),
      );

  /// Analyse chaque image de la caméra
  /// Retourne `true` si un visage stable est détecté
  Future<bool> processCameraImage(
    CameraImage image,
    int sensorOrientation,
  ) async {
    if (_isBusy) return false;
    _isBusy = true;

    bool hasStableFace = false;

    try {
      InputImage inputImage = await _safeConvertToInputImage(
        image,
        sensorOrientation,
      );
      try {
        await _faceDetector.processImage(inputImage);
      } catch (e) {
        debugPrint("❌ processImageprocessImage error: $e");
      }
      List<Face> faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        _stableFrames++;
        if (_stableFrames > 5) hasStableFace = true;
      } else {
        _stableFrames = 0;
      }
    } catch (e) {
      debugPrint("❌ FaceService error: $e");
    } finally {
      _isBusy = false;
    }

    return hasStableFace;
  }

  /// --- 🔥 Conversion sûre avec fallback ---
  Future<InputImage> _safeConvertToInputImage(
    CameraImage image,
    int sensorOrientation,
  ) async {
    try {
      // 🔹 Conversion standard (rapide)
      // 🔹
      return _convertToInputImage(image, sensorOrientation);
    } catch (e) {
      debugPrint(
        '⚠️ Conversion directe échouée, fallback vers fromFilePath... $e',
      );
      // 🔹 Conversion fallback : sauvegarde temporaire sur disque
      final dir = await getTemporaryDirectory();
      final tempFile = File(
        '${dir.path}/frame_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // On simule la capture brute : certains plugins te permettent
      // d’obtenir un JPEG depuis la preview (ici on écrit juste un fichier vide si besoin)
      await tempFile.writeAsBytes(_concatenatePlanes(image.planes));

      return InputImage.fromFilePath(tempFile.path);
    }
  }

  /// Conversion CameraImage → InputImage
  InputImage _convertToInputImage(CameraImage image, int sensorOrientation) {
    //final bytes = _concatenatePlanes(image.planes);
    InputImageRotation rotation =
        InputImageRotationValue.fromRawValue(sensorOrientation) ??
        InputImageRotation.rotation0deg;
    final bytes = Platform.isAndroid
        ? image.getNv21Uint8List()
        : Uint8List.fromList(
            image.planes.fold(
              <int>[],
              (List<int> previousValue, element) =>
                  previousValue..addAll(element.bytes),
            ),
          );

    InputImageMetadata inputImageData = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: Platform.isAndroid
          ? InputImageFormat.nv21
          : InputImageFormat.bgra8888,
      // InputImageFormatValue.fromRawValue(image.format.raw) ??
      // InputImageFormat.nv21,
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: inputImageData);
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  void dispose() {
    _faceDetector.close();
  }
}
