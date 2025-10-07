import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:yure_kyc_light/src/enum/step_enum.dart';
import 'package:yure_kyc_light/src/page/result_page.dart';
import 'package:yure_kyc_light/yure_kyc_light.dart';

class SignaturePage extends StatefulWidget {
  const SignaturePage({super.key, required this.scanResultat});
  final ScanResultatModel scanResultat;
  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  late SignatureController _controller;
  late ScanResultatModel scanResultat;
  @override
  void initState() {
    scanResultat = widget.scanResultat;
    _controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.white,
      exportBackgroundColor: Colors.black,
      onDrawStart: () => debugPrint('onDrawStart called!'),
      onDrawEnd: () async {
        debugPrint('onDrawEnd called!');
        scanResultat.signature = await _controller.toPngBytes();
        setState(() {
          scanResultat;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signature")),
      body: Column(
        children: [
          Signature(
            controller: _controller,
            width: 300,
            height: 300,
            backgroundColor: Colors.black87,
          ),
          if (scanResultat.signature != null)
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultPage(
                    scanResultatModel: scanResultat,
                    step: StepEnum.sign,
                  ),
                ),
              ),
              child: Text("Valider"),
            ),
        ],
      ),
    );
  }
}
