import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yure_kyc_light/yure_kyc_light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OcrService ocrService = OcrService();
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KYC Light Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade200,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.verified_user,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "KYC Light",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade900,
                            ),
                          ),
                          Text(
                            "Vérification d'identité",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Welcome message
                // Text(
                //   "Bienvenue",
                //   style: TextStyle(
                //     fontSize: 32,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.grey.shade800,
                //   ),
                // ),
                // const SizedBox(height: 12),
                Text(
                  "Commencez votre vérification d'identité en quelques étapes simples",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 48),

                // Features list
                _buildFeatureItem(
                  icon: Icons.document_scanner,
                  title: "Scan de document",
                  description:
                      "Scannez recto et verso de votre pièce d'identité",
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                _buildFeatureItem(
                  icon: Icons.face_retouching_natural,
                  title: "Photo selfie",
                  description: "Prenez une photo de votre visage",
                  color: Colors.green,
                ),
                const SizedBox(height: 20),
                _buildFeatureItem(
                  icon: Icons.draw,
                  title: "Signature",
                  description: "Signez électroniquement votre document",
                  color: Colors.orange,
                ),

                const Spacer(),

                // Start button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ExtractVersoWidget(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: Colors.blue.shade200,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Commencer la vérification",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.arrow_forward, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Info text
                Center(
                  child: Text(
                    "Vos données sont sécurisées et protégées",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // color: color,
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.red,
              // color: color.shade700,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Résultat de la vérification",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Vérification réussie",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Vos informations ont été extraites",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Images section
            if (widget.scanResultatModel.photo != null ||
                widget.scanResultatModel.docRectoImage != null) ...[
              Text(
                "Documents capturés",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 170,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (widget.scanResultatModel.facePhotoPath != null)
                        _buildImageCard(
                          child: Image.file(
                            File(widget.scanResultatModel.facePhotoPath!),
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                          label: "Selfie",
                        ),
                      if (widget.scanResultatModel.photo != null)
                        _buildImageCard(
                          child: Image.memory(
                            widget.scanResultatModel.photo!,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                          label: "Photo d'identité",
                        ),
                      if (widget.scanResultatModel.photo != null &&
                          widget.scanResultatModel.docRectoImage != null)
                        const SizedBox(width: 16),
                      if (widget.scanResultatModel.docRectoImage != null)
                        _buildImageCard(
                          child: Image.memory(
                            widget.scanResultatModel.docRectoImage!,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                          label: "Document recto",
                        ),
                      if (widget.scanResultatModel.docVersoImage != null)
                        _buildImageCard(
                          child: Image.memory(
                            widget.scanResultatModel.docVersoImage!,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                          label: "Document verso",
                        ),
                      if (widget.scanResultatModel.signature != null)
                        _buildImageCard(
                          child: Image.memory(
                            widget.scanResultatModel.signature!,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                          label: "Signature",
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],

            // Personal information
            Text(
              "Informations personnelles",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),

            Container(
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
                children: [
                  _buildInfoRow(
                    icon: Icons.person,
                    label: "Nom",
                    value:
                        widget.scanResultatModel.nom?.value ?? "Non renseigné",
                  ),
                  _buildInfoRow(
                    icon: Icons.person_outline,
                    label: "Prénom",
                    value:
                        widget.scanResultatModel.prenom?.value ??
                        "Non renseigné",
                  ),
                  _buildInfoRow(
                    icon: Icons.cake,
                    label: "Date de naissance",
                    value:
                        widget.scanResultatModel.birthdate?.value ??
                        "Non renseigné",
                  ),
                  _buildInfoRow(
                    icon: Icons.location_on,
                    label: "Lieu de naissance",
                    value:
                        widget.scanResultatModel.lieuNaissance?.value ??
                        "Non renseigné",
                  ),
                  _buildInfoRow(
                    icon: Icons.wc,
                    label: "Sexe",
                    value:
                        widget.scanResultatModel.sex?.value ?? "Non renseigné",
                  ),
                  _buildInfoRow(
                    icon: Icons.flag,
                    label: "Nationalité",
                    value:
                        widget.scanResultatModel.nationality?.value ??
                        "Non renseigné",
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Retour à l'accueil",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
}
