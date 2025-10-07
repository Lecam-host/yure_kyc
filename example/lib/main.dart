import 'package:flutter/material.dart';
import 'package:yure_kyc_light/yure_kyc_light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OcrService ocrService = OcrService();
  //await faceService.init();
  await ocrService.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (innerContext) => Scaffold(
          appBar: AppBar(title: Text("Demo KYC Light")),
          body: Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(innerContext).push(
                  MaterialPageRoute(builder: (context) => ExtractVersoWidget()),
                );
              },
              child: Text("Scanner la face verso"),
            ),
          ),
        ),
      ),
    );
  }
}

class ExtractVersoWidget extends StatefulWidget {
  const ExtractVersoWidget({super.key});

  @override
  State<ExtractVersoWidget> createState() => _ExtractVersoWidgetState();
}

class _ExtractVersoWidgetState extends State<ExtractVersoWidget> {
  ScanResultatModel? scanResultatModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KycWidget(
        callbackAction: (ScanResultatModel? results) {
          if (results == null) {
            Navigator.pop(context);
            return;
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ScanResultat(scanResultatModel: results),
            ),
          );
          setState(() {
            scanResultatModel = results;
          });
        },
      ),
    );
  }
}

class ScanResultat extends StatefulWidget {
  const ScanResultat({super.key, required this.scanResultatModel});
  final ScanResultatModel scanResultatModel;
  @override
  State<ScanResultat> createState() => _ScanResultatState();
}

class _ScanResultatState extends State<ScanResultat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Resultat final")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.scanResultatModel.photo != null)
              Image.memory(
                widget.scanResultatModel.photo!,
                height: 200,
                width: 200,
              ),
            if (widget.scanResultatModel.docImage != null)
              Image.memory(
                widget.scanResultatModel.docImage!,
                height: 200,
                width: 200,
              ),
            Text("Nom : ${widget.scanResultatModel.nom?.value}"),
            Text("Prenom : ${widget.scanResultatModel.prenom?.value}"),
            Text(
              "Date de naissance : ${widget.scanResultatModel.birthdate?.value}",
            ),
            Text(
              "Lieu de naissance : ${widget.scanResultatModel.lieuNaissance?.value}",
            ),
            Text("Sexe : ${widget.scanResultatModel.sex?.value}"),
            Text(
              "Nationalite : ${widget.scanResultatModel.nationality?.value}",
            ),
          ],
        ),
      ),
    );
  }
}
