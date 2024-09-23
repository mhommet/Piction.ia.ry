import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'qr_code_scanner_style.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({super.key});

  @override
  State<StatefulWidget> createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrCodeResult;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Code Scanner',
          style: QRCodeScannerStyle.appBarTitleStyle, // Style du titre
        ),
        backgroundColor:
            QRCodeScannerStyle.appBarBackgroundColor, // Couleur de fond AppBar
        elevation: 0,
        iconTheme: QRCodeScannerStyle.appBarIconTheme, // Style des icônes
      ),
      backgroundColor: QRCodeScannerStyle.backgroundColor, // Couleur de fond
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: QRCodeScannerStyle
                    .overlayBorderColor, // Couleur de la bordure
                borderRadius: QRCodeScannerStyle
                    .overlayBorderRadius, // Rayon de la bordure
                borderLength: QRCodeScannerStyle
                    .overlayBorderLength, // Longueur de la bordure
                borderWidth: QRCodeScannerStyle
                    .overlayBorderWidth, // Largeur de la bordure
                cutOutSize: QRCodeScannerStyle
                    .overlayCutOutSize, // Taille de la découpe
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: qrCodeResult != null
                  ? Text(
                      'Résultat du scan: $qrCodeResult',
                      style: QRCodeScannerStyle
                          .resultTextStyle, // Style du texte de résultat
                    )
                  : const Text(
                      'Scanne un QR Code',
                      style: QRCodeScannerStyle
                          .waitingTextStyle, // Style du texte d'attente
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeResult = scanData.code;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

void main() => runApp(const MaterialApp(home: QRCodeScannerPage()));
