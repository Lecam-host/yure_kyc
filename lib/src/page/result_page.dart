import 'package:flutter/material.dart';
import 'package:yure_kyc_light/src/page/face_page.dart';
import 'package:yure_kyc_light/yure_kyc_light.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    super.key,
    this.isFirstPage = false,
    this.scanResultatModel,
  });
  final ScanResultatModel? scanResultatModel;

  final bool isFirstPage;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resultat")),
      body: widget.isFirstPage && widget.scanResultatModel?.photo == null
          ? Column(
              children: [
                Text('Cette face n\'est pas conforme'),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Reprendre"),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (widget.scanResultatModel?.facePhotoPath != null)
                    Image.memory(
                      widget.scanResultatModel!.facePhotoPath!,
                      height: 200,
                      width: 200,
                    ),
                  if (widget.scanResultatModel?.photo != null)
                    Image.memory(
                      widget.scanResultatModel!.photo!,
                      height: 200,
                      width: 200,
                    ),
                  if (widget.scanResultatModel?.docImage != null)
                    Image.memory(
                      widget.scanResultatModel!.docImage!,
                      height: 200,
                      width: 200,
                    ),
                  Text("Nom : ${widget.scanResultatModel?.nom?.value}"),
                  Text("Prenom : ${widget.scanResultatModel?.prenom?.value}"),
                  Text(
                    "Date de naissance : ${widget.scanResultatModel?.birthdate?.value}",
                  ),
                  Text(
                    "Lieu de naissance : ${widget.scanResultatModel?.lieuNaissance?.value}",
                  ),
                  Text("Sexe : ${widget.scanResultatModel?.sex?.value}"),
                  Text(
                    "Nationalite : ${widget.scanResultatModel?.nationality?.value}",
                  ),
                  TextButton(
                    onPressed: () {
                      if (widget.scanResultatModel == null) {
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              FacePage(scanResultat: widget.scanResultatModel!),
                        ),
                      );
                    },
                    child: const Text("Continuer"),
                  ),
                ],
              ),
            ),
    );
  }
}
