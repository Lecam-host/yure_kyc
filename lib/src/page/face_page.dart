import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:yure_kyc_light/src/page/result_page.dart';
import 'package:yure_kyc_light/yure_kyc_light.dart';

class FacePage extends StatefulWidget {
  const FacePage({super.key, required this.scanResultat});
  final ScanResultatModel scanResultat;

  @override
  State<FacePage> createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  late FaceCameraController controller;

  @override
  void initState() {
    controller = FaceCameraController(
      autoCapture: true,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {
        ScanResultatModel r = widget.scanResultat;
        r.facePhotoPath = image!.readAsBytesSync();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultPage(isFirstPage: false, scanResultatModel: r),
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartFaceCamera(
        controller: controller,
        message: 'Center your face in the square',
      ),
    );
  }
}
