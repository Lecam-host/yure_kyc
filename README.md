🪪 Yure KYC Light
🔍 Description
.
Yure KYC Light est une application Flutter légère et modulaire permettant d’effectuer la vérification d’identité (KYC) de manière rapide, fiable et conforme.
Elle s’appuie sur le SDK Regula Document Reader pour la lecture automatique des pièces d’identité (CNI, passeport, permis, etc.) et intègre une capture selfie, signature électronique et extraction automatique des informations personnelles.

🚀 Fonctionnalités principales

📸 Scan de documents recto/verso : lecture et extraction des informations via OCR.

🤳 Selfie automatique : capture et comparaison faciale avec le document.

✍️ Signature électronique : ajout d’une signature numérique à la fin du processus.

📄 Extraction structurée : récupération automatique du nom, prénom, date de naissance, sexe, nationalité, etc.

🧩 Callback intégré : permet de récupérer le résultat complet du scan dans le projet parent.

💾 Stockage local temporaire pour les images et données KYC.

🔒 Respect de la confidentialité et sécurité des données personnelles.

🧱 Architecture

L’application suit une architecture Flutter modulaire avec séparation claire des responsabilités :

lib/
│
├── src/
│   ├── enum/                → Définitions d’énumérations (étapes du scan, etc.)
│   ├── model/               → Modèles de données (ScanResultatModel, etc.)
│   ├── service/             → Services d’intégration (OCR, caméra, signature)
│   ├── page/                → Pages principales (KycWidget, ResultPage, etc.)
│   └── utils/               → Fonctions utilitaires
│
└── yure_kyc_light.dart      → Point d’entrée exporté pour intégration SDK

🧩 Intégration dans un projet Flutter
1️⃣ Installation

Ajoutez la dépendance dans votre pubspec.yaml :

dependencies:
  yure_kyc_light:
    path: ../yure_kyc_light

2️⃣ Initialisation du service OCR
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OcrService ocrService = OcrService();
  await ocrService.init();
  runApp(const MyApp());
}

3️⃣ Utilisation du widget KYC
KycWidget(
  callbackAction: (ScanResultatModel? result) {
    if (result != null) {
      print("Nom : ${result.nom?.value}");
      print("Prénom : ${result.prenom?.value}");
    }
  },
);

📸 Exemple d’interface

L’exemple fourni (example/lib/main.dart) contient :

Une page d’accueil claire et fluide ;

Un bouton “Commencer la vérification” ;

Un flux complet jusqu’à la page de résultat (ScanResultat) affichant :

Les documents capturés ;

Les informations extraites ;

Un bouton pour revenir à l’accueil.

🧰 Dépendances principales
Package	Utilisation
flutter_document_reader_api	Lecture OCR des documents
image_picker	Capture photo/selfie
signature	Signature numérique
path_provider	Gestion du stockage local
flutter_bloc (optionnel)	Gestion d’état (pour intégration avancée)
⚙️ Configuration Android

Ajoutez la licence Regula dans vos assets :

assets/
  regula.license


Et référencez-la dans pubspec.yaml :

flutter:
  assets:
    - assets/regula.license

🍏 Configuration iOS

Dans le fichier ios/Podfile :

platform :ios, '13.0'
use_frameworks!
use_modular_headers!


Assurez-vous d’avoir ajouté les permissions :

<key>NSCameraUsageDescription</key>
<string>La caméra est utilisée pour capturer vos documents et selfies.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Utilisé pour enregistrer temporairement les images KYC.</string>

🧪 Exemple de test
test('OCR Service init', () async {
  final service = OcrService();
  final initialized = await service.init();
  expect(initialized, true);
});

