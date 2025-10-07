import 'package:flutter/material.dart';
import 'package:flutter_document_reader_api/flutter_document_reader_api.dart';
import 'package:yure_kyc_light/src/enum/step_enum.dart';
import 'package:yure_kyc_light/src/page/result_page.dart';
import 'package:yure_kyc_light/yure_kyc_light.dart';

class KycWidget extends StatefulWidget {
  const KycWidget({super.key, required this.callbackAction});
  final Function(ScanResultatModel? results) callbackAction;
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
    // await ocrService.init();
    Results? results = await ocrService.scan(StepEnum.recto);

    if (results == null) {
      Navigator.pop(context);
      return;
    }
    ScanResultatModel convertResult = await ocrService
        .convertScanResultInScanResultatModel(results);
    // widget.callbackAction(convertResult);
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => ResultPage(
              scanResultatModel: convertResult,
              step: StepEnum.recto,
            ),
          ),
        )
        .then((finalResult) {
          if (finalResult != null) {
            widget.callbackAction(finalResult); // ✅ résultat final
          } else {
            widget.callbackAction(null);
            Navigator.pop(context);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return
    //FacePage(scanResultat: ScanResultatModel());
    Center(child: CircularProgressIndicator());
  }
}
