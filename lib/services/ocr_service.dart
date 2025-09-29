import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/kyc_result.dart';

class OcrService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<KycResult> processDocument(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    final text = recognizedText.text;

    // Heuristiques simples
    final idRegex = RegExp(r'[A-Z0-9]{6,}');
    final dateRegex = RegExp(r'(\d{2}[\/\-]\d{2}[\/\-]\d{4})');

    String? idNumber = idRegex.firstMatch(text)?.group(0);
    String? dobRaw = dateRegex.firstMatch(text)?.group(0);
    DateTime? dob;
    if (dobRaw != null) {
      final parts = dobRaw.split(RegExp(r'[\/\-]'));
      if (parts.length == 3) {
        dob = DateTime.tryParse("${parts[2]}-${parts[1]}-${parts[0]}");
      }
    }

    String? name;
    for (final block in recognizedText.blocks) {
      final candidate = block.text.trim();
      if (candidate == candidate.toUpperCase() && candidate.length > 3) {
        name = candidate;
        break;
      }
    }

    return KycResult(
      idNumber: idNumber,
      name: name,
      dob: dob,
      rawText: text,
      status: KycStatus.pending,
    );
  }

  Future<void> dispose() async {
    await _textRecognizer.close();
  }
}
