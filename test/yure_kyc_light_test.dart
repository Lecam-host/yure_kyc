import 'package:flutter_test/flutter_test.dart';
import 'package:yure_kyc_light/src/models/kyc_result.dart';

void main() {
  test('OCR parsing simple', () {
    final result = KycResult(idNumber: "CNI123", name: "Jean Lecam");
    expect(result.idNumber, "CNI123");
  });
}
