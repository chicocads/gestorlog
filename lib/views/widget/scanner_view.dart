import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<String?> showBarcodeScannerBottomSheet(
  BuildContext context, {
  double heightFactor = 0.45,
  String helperText = 'Aponte para o código de barra',
}) {
  bool scanned = false;
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black,
    builder: (_) => SizedBox(
      height: MediaQuery.of(context).size.height * heightFactor,
      child: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (scanned) return;
              final rawValue = capture.barcodes.firstOrNull?.rawValue;
              if (rawValue == null || rawValue.isEmpty) return;
              scanned = true;
              SystemSound.play(SystemSoundType.alert);
              HapticFeedback.selectionClick();
              Navigator.of(context).pop(rawValue);
            },
          ),
          Center(
            child: Container(
              width: 240,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.85),
            child: Text(
              helperText,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    ),
  );
}

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  bool _scanned = false;

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final rawValue = capture.barcodes.firstOrNull?.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;
    _scanned = true;
    SystemSound.play(SystemSoundType.alert);
    HapticFeedback.selectionClick();
    Navigator.of(context).pop(rawValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear Código de Barra')),
      body: Stack(
        children: [
          MobileScanner(onDetect: _onDetect),
          Center(
            child: Container(
              width: 240,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Align(
            alignment: Alignment(0, 0.55),
            child: Text(
              'Aponte para o código de barra do produto',
              style: TextStyle(color: Colors.white, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
