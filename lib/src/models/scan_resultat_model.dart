import 'dart:typed_data';

class ScanResultatModel {
  ScanObjet? nom;
  ScanObjet? prenom;
  ScanObjet? birthdate;
  ScanObjet? nationality;
  Uint8List? photo;
  Uint8List? docImage;
  ScanObjet? sex;
  ScanObjet? numerodoc;
  ScanObjet? taille;
  ScanObjet? dateExpiration;
  ScanObjet? lieuNaissance;
  ScanObjet? typePiece;
  ScanObjet? iss;
  ScanObjet? issuingAuthority;
  ScanObjet? issuingPlace;

  ScanObjet? profession;
  ScanObjet? nni;
  ScanObjet? dateEmission;
  ScanObjet? documentClassCode;
  ScanObjet? nameEtatDeDelivrance;
  ScanObjet? issuingStateCode;
  Uint8List? facePhotoPath;

  ScanResultatModel({
    this.nom,
    this.issuingAuthority,
    this.issuingPlace,
    this.prenom,
    this.birthdate,
    this.nationality,
    this.photo,
    this.docImage,
    this.sex,
    this.numerodoc,
    this.taille,
    this.dateExpiration,
    this.lieuNaissance,
    this.typePiece,
    this.profession,
    this.nni,
    this.dateEmission,
    this.issuingStateCode,
    this.nameEtatDeDelivrance,
    this.facePhotoPath,
  });

  ScanResultatModel merge(ScanResultatModel other) {
    return ScanResultatModel(
      nom: nom ?? other.nom,
      prenom: prenom ?? other.prenom,
      birthdate: birthdate ?? other.birthdate,
      nationality: nationality ?? other.nationality,
      photo: photo ?? other.photo,
      docImage: docImage ?? other.docImage,
      sex: sex ?? other.sex,
      numerodoc: numerodoc ?? other.numerodoc,
      taille: taille ?? other.taille,
      dateExpiration: dateExpiration ?? other.dateExpiration,
      lieuNaissance: lieuNaissance ?? other.lieuNaissance,
      typePiece: typePiece ?? other.typePiece,
      profession: profession ?? other.profession,
      nni: nni ?? other.nni,
      dateEmission: dateEmission ?? other.dateEmission,
      issuingStateCode: issuingStateCode ?? other.issuingStateCode,
      nameEtatDeDelivrance: nameEtatDeDelivrance ?? other.nameEtatDeDelivrance,
      issuingAuthority: issuingAuthority ?? other.issuingAuthority,
      issuingPlace: issuingPlace ?? other.issuingPlace,
      facePhotoPath: facePhotoPath ?? other.facePhotoPath,
    );
  }
}

class ScanObjet {
  String label;
  String? value;
  ScanObjet({required this.label, this.value});
}
