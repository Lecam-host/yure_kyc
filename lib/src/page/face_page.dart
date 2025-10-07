import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:yure_kyc_light/src/enum/step_enum.dart';
import 'package:yure_kyc_light/src/page/result_page.dart';
import 'package:yure_kyc_light/yure_kyc_light.dart';

class FacePage extends StatefulWidget {
  const FacePage({super.key, required this.scanResultat});
  final ScanResultatModel scanResultat;

  @override
  State<FacePage> createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  late CameraController _cameraController;
  late FaceService _faceService;
  bool _isInitialized = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _faceService = FaceService();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController.initialize();
    await _cameraController.startImageStream(_onNewFrame);

    setState(() => _isInitialized = true);
  }

  Future<void> _onNewFrame(CameraImage image) async {
    if (_isCapturing) return;

    bool faceStable = await _faceService.processCameraImage(
      image,
      _cameraController.description.sensorOrientation,
    );

    if (faceStable) {
      _isCapturing = true;
      await _cameraController.stopImageStream();
      final picture = await _cameraController.takePicture();
      if (!mounted) return;
      ScanResultatModel scanResul = widget.scanResultat;
      scanResul.facePhotoPath = picture.path;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPreviewPage(scanResultat: scanResul),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isInitialized
          ? Stack(
              children: [
                CameraPreview(_cameraController),
                Center(
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.greenAccent, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Place ton visage dans le cadre",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class ResultPreviewPage extends StatelessWidget {
  final ScanResultatModel scanResultat;
  const ResultPreviewPage({super.key, required this.scanResultat});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Votre selfie"),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Center(child: Image.file(File(scanResultat.facePhotoPath!))),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Reprendre"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultPage(
                      scanResultatModel: scanResultat,
                      step: StepEnum.face,
                    ),
                  ),
                );
              },
              child: const Text("Valider"),
            ),
          ],
        ),
      ),
    );
  }
}
