enum KycStatus { pending, verified, failed }

class KycResult {
  final String? idNumber;
  final String? name;
  final DateTime? dob;
  final String? facePhotoPath;
  final String? rawText;
  final KycStatus status;

  KycResult({
    this.idNumber,
    this.name,
    this.dob,
    this.facePhotoPath,
    this.rawText,
    this.status = KycStatus.pending,
  });

  Map<String, dynamic> toJson() => {
    "idNumber": idNumber,
    "name": name,
    "dob": dob?.toIso8601String(),
    "facePhoto": facePhotoPath,
    "rawText": rawText,
    "status": status.name,
  };
}
