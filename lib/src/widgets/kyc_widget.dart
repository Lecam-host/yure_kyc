import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_reader_api/flutter_document_reader_api.dart';
import 'package:yure_kyc_light/src/page/result_page.dart';
import 'package:yure_kyc_light/yure_kyc_light.dart';

class KycWidget extends StatefulWidget {
  const KycWidget({
    super.key,
    required this.callbackAction,
    this.isFirstFace = false,
  });
  final Function(ScanResultatModel? results) callbackAction;
  final bool isFirstFace;
  @override
  State<KycWidget> createState() => _KycWidgetState();
}

class _KycWidgetState extends State<KycWidget> {
  OcrService ocrService = OcrService();

  @override
  void initState() {
    s();
    super.initState();
  }

  s() async {
    await FaceCamera.initialize();
    await ocrService.init();
    Results? results = await ocrService.scan(widget.isFirstFace);

    if (results == null) return;
    ScanResultatModel convertResult = await ocrService
        .convertScanResultInScanResultatModel(results);
    // widget.callbackAction(convertResult);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultPage(scanResultatModel: convertResult),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
    // Center(
    //   child: Column(
    //     children: [
    //       ElevatedButton(onPressed: () async {}, child: const Text("Scan")),
    //       ElevatedButton(
    //         onPressed: ocrService.recognize,
    //         child: const Text("Recognize"),
    //       ),
    //     ],
    //   ),
    // );
  }
}
