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
        Navigator.pop(context, _model);
        Navigator.pop(context, _model);
        break;
    }
  }

  String _getStepTitle() {
    switch (_step) {
      case StepEnum.recto:
        return "Vérification recto";
      case StepEnum.verso:
        return "Vérification verso";
      case StepEnum.face:
        return "Vérification selfie";
      case StepEnum.sign:
        return "Vérification signature";
    }
  }

  IconData _getStepIcon() {
    switch (_step) {
      case StepEnum.recto:
      case StepEnum.verso:
        return Icons.credit_card;
      case StepEnum.face:
        return Icons.face;
      case StepEnum.sign:
        return Icons.draw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getStepIcon(),
                  color: Colors.blue.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _getStepTitle(),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: _step == StepEnum.recto && _model.photo == null
            ? _buildErrorView()
            : _buildSuccessView(),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: Colors.red.shade700,
                size: 64,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Oups !",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Vous avez scanné la mauvaise face",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _scanNextSide(StepEnum.recto),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Reprendre le scan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Images section
                if (_model.facePhotoPath != null ||
                    _model.photo != null ||
                    _model.docRectoImage != null ||
                    _model.docVersoImage != null ||
                    _model.signature != null)
                  _buildImagesSection(),

                const SizedBox(height: 24),

                // Information card
                _buildInfoCard(),

                const SizedBox(height: 24),

                // Progress indicator
                _buildProgressIndicator(),
              ],
            ),
          ),
        ),

        // Bottom action buttons
        _buildBottomActions(),
      ],
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Photos capturées",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (_model.facePhotoPath != null)
                _buildImageCard(
                  child: Image.file(
                    io.File(_model.facePhotoPath!),
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                  label: "Selfie",
                ),
              if (_model.photo != null)
                _buildImageCard(
                  child: Image.memory(
                    _model.photo!,
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                  label: "Photo d'identité",
                ),
              if (_model.docRectoImage != null)
                _buildImageCard(
                  child: Image.memory(
                    _model.docRectoImage!,
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                  label: "Document recto",
                ),

              if (_model.docVersoImage != null)
                _buildImageCard(
                  child: Image.memory(
                    _model.docVersoImage!,
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                  label: "Document verso",
                ),
              if (_model.signature != null)
                _buildImageCard(
                  child: Image.memory(
                    _model.signature!,
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                  label: "Signature",
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard({required Widget child, required String label}) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: child,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final fields = [
      {'icon': Icons.person, 'label': 'Nom', 'value': _model.nom?.value},
      {
        'icon': Icons.person_outline,
        'label': 'Prénom',
        'value': _model.prenom?.value,
      },
      {
        'icon': Icons.cake,
        'label': 'Date de naissance',
        'value': _model.birthdate?.value,
      },
      {
        'icon': Icons.location_on,
        'label': 'Lieu de naissance',
        'value': _model.lieuNaissance?.value,
      },
      {'icon': Icons.wc, 'label': 'Sexe', 'value': _model.sex?.value},
      {
        'icon': Icons.flag,
        'label': 'Nationalité',
        'value': _model.nationality?.value,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 24),
                const SizedBox(width: 12),
                Text(
                  "Informations extraites",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...fields.asMap().entries.map((entry) {
            final index = entry.key;
            final field = entry.value;
            final isLast = index == fields.length - 1;
            return _buildInfoRow(
              icon: field['icon'] as IconData,
              label: field['label'] as String,
              value: field['value'] as String? ?? 'Non renseigné',
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final steps = [
      {'step': StepEnum.recto, 'label': 'Recto'},
      {'step': StepEnum.verso, 'label': 'Verso'},
      {'step': StepEnum.face, 'label': 'Selfie'},
      {'step': StepEnum.sign, 'label': 'Signature'},
    ];

    final currentIndex = steps.indexWhere((s) => s['step'] == _step);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Progression",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(steps.length, (index) {
              final isCompleted = index < currentIndex;
              final isCurrent = index == currentIndex;
              final isLast = index == steps.length - 1;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isCompleted || isCurrent
                                  ? Colors.green.shade400
                                  : Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: isCurrent
                                            ? Colors.white
                                            : Colors.grey.shade400,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            steps[index]['label'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              color: isCompleted || isCurrent
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade400,
                              fontWeight: isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Container(
                        height: 2,
                        width: 20,
                        color: isCompleted
                            ? Colors.green.shade400
                            : Colors.grey.shade200,
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_step == StepEnum.recto) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _scanNextSide(StepEnum.verso),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.credit_card, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Scanner la face verso",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FacePage(scanResultat: _model),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Passer au selfie",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ] else if (_step == StepEnum.verso) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _goToNextStep(_step),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.face, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Passer au selfie",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (_step == StepEnum.face) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _goToNextStep(_step),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.draw, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Continuer vers la signature",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (_step == StepEnum.sign) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _goToNextStep(_step),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Terminer le KYC",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
