import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class FaceService {
  final _faceDetector = FaceDetector(
    options: FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate),
  );

  Future<String?> extractFace(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isEmpty) return null;

    final face = faces.first;
    final bytes = await imageFile.readAsBytes();
    final original = img.decodeImage(bytes)!;

    final rect = face.boundingBox;
    final crop = img.copyCrop(
      original,
      x: rect.left.toInt().clamp(0, original.width),
      y: rect.top.toInt().clamp(0, original.height),
      width: rect.width.toInt().clamp(0, original.width),
      height: rect.height.toInt().clamp(0, original.height),
    );

    final tmp = await getTemporaryDirectory();
    final outFile = File(
      "${tmp.path}/face_${DateTime.now().millisecondsSinceEpoch}.png",
    );
    await outFile.writeAsBytes(img.encodePng(crop));
    return outFile.path;
  }

  Future<void> dispose() async {
    await _faceDetector.close();
  }
}
