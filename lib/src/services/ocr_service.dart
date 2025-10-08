import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_document_reader_api/flutter_document_reader_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yure_kyc_light/src/enum/step_enum.dart';
import 'package:yure_kyc_light/src/models/scan_resultat_model.dart';

var documentReader = DocumentReader.instance;
var selectedScenario = Scenario.OCR;
var doRfid = false;
var isReadingRfid = false;

class OcrService {
  Future<ScanObjet?> getValueWithFieldType(
    String label,
    FieldType fieldType,
    Results results,
  ) async {
    String? r = await results.textFieldValueByType(fieldType);
    if (r != null) {
      return ScanObjet(value: r, label: label);
    } else {
      return null;
    }
  }

  Future<void> init() async {
    if (!await initialize()) return;
    documentReader.availableScenarios;
    await documentReader.isRFIDAvailableForUse();
    // setCanRfid();
    // setScenarios();

    // setStatus("Ready");
  }

  Future<Results?> scan(StepEnum step) async {
    if (!await documentReader.isReady) return null;

    final completer = Completer<Results?>();

    documentReader.startScanner(ScannerConfig.withScenario(selectedScenario), (
      DocReaderAction action,
      Results? r,
      DocReaderException? error,
    ) async {
      if (action.stopped() && !shouldRfid(r)) {
        inspect(r);
        completer.complete(r); // on complète quand c'est fini
      }

      // En cas d'erreur, on complète aussi pour éviter de bloquer
      if (error != null && !completer.isCompleted) {
        completer.completeError(error);
      }
    });

    return completer.future; // on attend le résultat final
  }

  Future<Uint8List?> pickImage() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return null;
    return await file.readAsBytes();
  }

  void recognize() async {
    if (!await documentReader.isReady) return;
    var image = await pickImage();
    if (image == null) return;

    documentReader.recognize(
      RecognizeConfig.withScenario(selectedScenario, image: image),
      handleCompletion,
    );
  }

  void handleCompletion(
    DocReaderAction action,
    Results? results,
    DocReaderException? error,
  ) {
    handleException(error);
    if (action.stopped() && !shouldRfid(results)) {
      // displayResults(results);
      inspect(results);
    } else if (action.finished() && shouldRfid(results)) {
      isReadingRfid = true;
      // readRfid();
    }
  }

  // void displayResults(Results? results) async {
  //   isReadingRfid = false;
  //   if (results == null) return;

  //   var name = await results.textFieldValueByType(
  //     FieldType.SURNAME_AND_GIVEN_NAMES,
  //   );
  //   var docImage = await results.graphicFieldImageByType(
  //     GraphicFieldType.DOCUMENT_IMAGE,
  //   );
  //   var portrait = await results.graphicFieldImageByType(
  //     GraphicFieldType.PORTRAIT,
  //   );
  //   portrait =
  //       await results.graphicFieldImageByTypeSource(
  //         GraphicFieldType.PORTRAIT,
  //         ResultType.RFID_IMAGE_DATA,
  //       ) ??
  //       portrait;
  // }

  Future<ScanResultatModel> convertScanResultInScanResultatModel(
    Results r,
  ) async {
    return ScanResultatModel(
      nom: await getValueWithFieldType('Nom', FieldType.SURNAME, r),
      prenom: await getValueWithFieldType('Prenom', FieldType.GIVEN_NAMES, r),
      birthdate: await getValueWithFieldType(
        'Date de naissance',
        FieldType.DATE_OF_BIRTH,
        r,
      ),
      nationality: await getValueWithFieldType(
        'Nationalite',
        FieldType.NATIONALITY,
        r,
      ),
      photo: await r.graphicFieldImageByType(GraphicFieldType.PORTRAIT),
      docRectoImage: await r.graphicFieldImageByType(
        GraphicFieldType.DOCUMENT_IMAGE,
      ),
      sex: await getValueWithFieldType('Sexe', FieldType.SEX, r),
      numerodoc: await getValueWithFieldType(
        'Numero de document',
        FieldType.DOCUMENT_NUMBER,
        r,
      ),
      taille: await getValueWithFieldType('Taille', FieldType.HEIGHT, r),
      dateExpiration: await getValueWithFieldType(
        'Date d\'expiration',
        FieldType.DATE_OF_EXPIRY,
        r,
      ),
      lieuNaissance: await getValueWithFieldType(
        'Lieu de naissance',
        FieldType.PLACE_OF_BIRTH,
        r,
      ),
      typePiece: r.documentType != null
          ? r.documentType!.isNotEmpty
                ? ScanObjet(
                    label: 'Type de piece',
                    value: r.documentType![0].name,
                  )
                : null
          : null,
      profession: await getValueWithFieldType(
        'Profession',
        FieldType.PROFESSION,
        r,
      ),
      nni: await getValueWithFieldType(
        'Nni',
        FieldType.LINE_2_OPTIONAL_DATA,
        r,
      ),
      dateEmission: await getValueWithFieldType(
        'Date d\'emission',
        FieldType.DATE_OF_ISSUE,
        r,
      ),
      issuingStateCode: await getValueWithFieldType(
        "Code de l'etat emeteur",
        FieldType.ISSUING_STATE_CODE,
        r,
      ),
      nameEtatDeDelivrance: await getValueWithFieldType(
        "Etat de délivrance",
        FieldType.ISSUING_STATE_NAME,
        r,
      ),
      issuingAuthority: await getValueWithFieldType(
        "Autorité d'emission",
        FieldType.AUTHORITY,
        r,
      ),
      issuingPlace: await getValueWithFieldType(
        "Lieu d'emission",
        FieldType.PLACE_OF_ISSUE,
        r,
      ),
    );
  }
  //var readRfid = () => documentReader.rfid(RFIDConfig(handleCompletion));

  bool shouldRfid(Results? results) =>
      doRfid && !isReadingRfid && results != null && results.chipPage != 0;

  initialize() async {
    ByteData license = await rootBundle.load("assets/regula/regula.license");
    var initConfig = InitConfig(license);

    initConfig.delayedNNLoad = true;
    var (success, error) = await documentReader.initialize(initConfig);
    // var (success, error) = await DocumentReader.instance.prepareDatabase(
    //   "Full",
    //   (value) {
    //     print(value);
    //   },
    // );
    // await DocumentReader.instance.runAutoUpdate("Full", (value) {
    //   print(value);
    // });
    // await DocumentReader.instance.checkDatabaseUpdate("Full");
    // var (success, error) = await documentReader.initialize(initConfig);
    if (success) {
      handleCompletion;
      return true;
    } else {
      handleException(error);
      return false;
    }

    // return success;
  }
}

void handleException(DocReaderException? error) {
  if (error != null) {
    print("${error.code}: ${error.message}");
  }
}
