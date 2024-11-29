import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:save_receipt/color/themes/main_theme.dart';

class ExpandableFloatingActionButton extends StatefulWidget {
  const ExpandableFloatingActionButton({super.key, required this.onDocumentScanning, required this.onImageProcessing});

  final Function() onDocumentScanning;
  final Function() onImageProcessing;

  @override
  State<ExpandableFloatingActionButton> createState() => _ExpandableFloatingActionButtonState();
  
}

class _ExpandableFloatingActionButtonState extends State<ExpandableFloatingActionButton> {
  final _expandableFabKey = GlobalKey<ExpandableFabState>();

  void toggleFloatingActionButton() {
    if (_expandableFabKey.currentState != null) {
      _expandableFabKey.currentState!.toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      key: _expandableFabKey,
        // type: ExpandableFabType.fan,
        pos: ExpandableFabPos.center,
        distance: 90,
        fanAngle: 130,
        overlayStyle: const ExpandableFabOverlayStyle(
          blur: 1.0,
          color: Color.fromARGB(100, 100, 100, 100),
        ),
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.receipt_sharp),
          fabSize: ExpandableFabSize.regular,
          shape: const CircleBorder(),
          foregroundColor: Colors.white,
          backgroundColor: mainTheme.mainColor,
        ),
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.close),
          fabSize: ExpandableFabSize.regular,
          backgroundColor: mainTheme.extraLightMainColor,
          foregroundColor: mainTheme.mainColor,
          shape: const CircleBorder(),
        ),
        children: [
          Column(
            children: [
              FloatingActionButton(
                heroTag: null,
                backgroundColor: mainTheme.mainColor,
                onPressed: () async {
                  toggleFloatingActionButton();
                  await widget.onDocumentScanning();
                },
                child: Image.asset(
                  'assets/googleScannerIcon.png',
                  height: 24,
                  width: 24,
                ),
              ),
              Text(
                "scan",
                style: TextStyle(color: mainTheme.mainColor),
              ),
            ],
          ),
          Column(
            children: [
              FloatingActionButton(
                backgroundColor: mainTheme.mainColor,
                heroTag: null,
                onPressed: () async {
                  toggleFloatingActionButton();
                  await widget.onImageProcessing();
                },
                child: const Icon(
                  Icons.drive_folder_upload,
                ),
              ),
              Text(
                "import",
                style: TextStyle(color: mainTheme.mainColor),
              ),
            ],
          ),
        ],
      );
  }
}