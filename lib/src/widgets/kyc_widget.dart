import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yure_kyc_light/yure_kyc_light.dart';

class KycWidget extends StatefulWidget {
  const KycWidget({super.key});

  @override
  State<KycWidget> createState() => _KycWidgetState();
}

class _KycWidgetState extends State<KycWidget> {
  final yureKyc = YureKyc();
  KycResult? _result;

  Future<void> _scan() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.camera);
    if (xfile != null) {
      final res = await yureKyc.processCni(File(xfile.path));
      setState(() => _result = res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: _scan, child: const Text("Scanner CNI")),
        if (_result != null) ...[
          Text("Nom: ${_result!.name ?? 'Inconnu'}"),
          Text("ID: ${_result!.idNumber ?? 'N/A'}"),
          Text("Naissance: ${_result!.dob ?? 'N/A'}"),
          if (_result!.facePhotoPath != null)
            Image.file(File(_result!.facePhotoPath!), width: 120),
        ],
      ],
    );
  }
}
