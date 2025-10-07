import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_document_reader_api/flutter_document_reader_api.dart';
import 'package:yure_kyc_light/src/enum/step_enum.dart';
import 'package:yure_kyc_light/src/page/face_page.dart';
import 'package:yure_kyc_light/src/page/signature_page.dart';
import 'package:yure_kyc_light/yure_kyc_light.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    super.key,
    required this.step,
    required this.scanResultatModel,
  });

  final ScanResultatModel scanResultatModel;
  final StepEnum step;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late ScanResultatModel _model;
  late StepEnum _step;

  @override
  void initState() {
    super.initState();
    _model = widget.scanResultatModel;
    _step = widget.step;
  }

  Future<void> _scanNextSide(StepEnum nextStep) async {
    final ocrService = OcrService();
    Results? results = await ocrService.scan(nextStep);

    if (results == null) return;
    final convertResult = await ocrService.convertScanResultInScanResultatModel(
      results,
    );

    setState(() {
      _model.merge(convertResult);
      _step = nextStep;
    });

    // Re-affiche la page mise à jour

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(scanResultatModel: _model, step: nextStep),
      ),
    );
  }

  void _goToNextStep(StepEnum step) {
    switch (step) {
      case StepEnum.recto:
        _scanNextSide(StepEnum.verso);
        break;
      case StepEnum.verso:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => FacePage(scanResultat: _model)),
        );
        break;
      case StepEnum.face:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SignaturePage(scanResultat: _model),
          ),
        );
        break;
      case StepEnum.sign:
        // Navigator.of(context).popUntil(
        //   (route) => route.isFirst,
        // ); // ou .popUntil((r) => r.settings.name == '/')
        //widget.scanResultatModel; // juste pour clarté
        Navigator.pop(context, _model);
        Navigator.pop(context, _model);
        // Navigator.pop(context, _model);
        // Navigator.pop(context, _model);
        // Navigator.pop(context, _model);
        // Navigator.pop(
        //   context,
        //   _model,
        // ); // ✅ renvoie le résultat final au KycWidget
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Résultat du KYC"),
          automaticallyImplyLeading: false,
        ),
        body: _step == StepEnum.recto && _model.photo == null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Center(
                      child: const Text(
                        "Vous avez scanné la mauvaise face",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        child: const Text("Reprendre"),
                        onPressed: () => _scanNextSide(StepEnum.recto),
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_model.facePhotoPath != null)
                        Image.file(io.File(_model.facePhotoPath!), height: 200),
                      if (_model.photo != null)
                        Image.memory(_model.photo!, height: 200, width: 200),
                      if (_model.docImage != null)
                        Image.memory(_model.docImage!, height: 200, width: 200),
                      const SizedBox(height: 16),
                      Text("Nom : ${_model.nom?.value ?? ''}"),
                      Text("Prénom : ${_model.prenom?.value ?? ''}"),
                      Text(
                        "Date de naissance : ${_model.birthdate?.value ?? ''}",
                      ),
                      Text(
                        "Lieu de naissance : ${_model.lieuNaissance?.value ?? ''}",
                      ),
                      Text("Sexe : ${_model.sex?.value ?? ''}"),
                      Text("Nationalité : ${_model.nationality?.value ?? ''}"),
                      const SizedBox(height: 32),

                      // 🔹 Boutons selon l’étape actuelle
                      if (_step == StepEnum.recto) ...[
                        ElevatedButton(
                          onPressed: () => _scanNextSide(StepEnum.verso),
                          child: const Text("Scanner la face verso"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FacePage(scanResultat: _model),
                              ),
                            );
                          },
                          child: const Text("Passer au selfie"),
                        ),
                      ] else if (_step == StepEnum.verso) ...[
                        ElevatedButton(
                          onPressed: () => _goToNextStep(_step),
                          child: const Text("Passer au selfie"),
                        ),
                      ] else if (_step == StepEnum.face) ...[
                        ElevatedButton(
                          onPressed: () => _goToNextStep(_step),
                          child: const Text("Continuer vers la signature"),
                        ),
                      ] else if (_step == StepEnum.sign) ...[
                        ElevatedButton(
                          onPressed: () => _goToNextStep(_step),
                          child: const Text("Terminer le KYC"),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
