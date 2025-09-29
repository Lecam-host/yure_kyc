import 'dart:io';
import 'models/kyc_result.dart';
import 'services/ocr_service.dart';
import 'services/face_service.dart';

class YureKyc {
  final OcrService _ocr = OcrService();
  final FaceService _face = FaceService();

  /// Lance l’OCR + extraction visage
  Future<KycResult> processCni(File cniImage) async {
    final ocrResult = await _ocr.processDocument(cniImage);
    final facePath = await _face.extractFace(cniImage);

    return KycResult(
      idNumber: ocrResult.idNumber,
      name: ocrResult.name,
      dob: ocrResult.dob,
      rawText: ocrResult.rawText,
      facePhotoPath: facePath,
      status: KycStatus.pending,
    );
  }

  Future<void> dispose() async {
    await _ocr.dispose();
    await _face.dispose();
  }
}
