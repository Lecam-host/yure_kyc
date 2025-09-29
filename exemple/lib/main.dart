import 'package:flutter/material.dart';
import 'package:yure_kyc_light/widgets/kyc_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Demo KYC Light")),
        body: Center(child: KycWidget()),
      ),
    );
  }
}
