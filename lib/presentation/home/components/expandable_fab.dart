import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
export 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:save_receipt/core/themes/main_theme.dart';

class ExpandableFloatingActionButton extends StatefulWidget {
  const ExpandableFloatingActionButton({
    super.key,
    required this.onDocumentScanning,
    required this.onImageProcessing,
  });

  final Function() onDocumentScanning;
  final Function() onImageProcessing;

  @override
  State<ExpandableFloatingActionButton> createState() =>
      _ExpandableFloatingActionButtonState();
}

class _ExpandableFloatingActionButtonState
    extends State<ExpandableFloatingActionButton> {
  final _expandableFabKey = GlobalKey<ExpandableFabState>();

  void toggleFloatingActionButton() {
    if (_expandableFabKey.currentState != null) {
      _expandableFabKey.currentState!.toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle buttonLabelsTextStyle =
        TextStyle(color: mainTheme.mainColor, fontWeight: FontWeight.w800);
    return ExpandableFab(
      key: _expandableFabKey,
      // type: ExpandableFabType.fan,
      pos: ExpandableFabPos.right,
      distance: 120,
      fanAngle: 90,
      openCloseStackAlignment: Alignment.bottomCenter,
      overlayStyle: ExpandableFabOverlayStyle(
        blur: 1.0,
        color: Colors.white.withOpacity(0.5),
      ),
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.receipt_sharp),
        fabSize: ExpandableFabSize.regular,
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
            FloatingActionButton.small(
              heroTag: null,
              backgroundColor: mainTheme.mainColor,
              onPressed: () async {
                toggleFloatingActionButton();
                await widget.onDocumentScanning();
              },
              shape: const CircleBorder(),
              child: Image.asset(
                'assets/googleScannerIcon.png',
                height: 24,
                width: 24,
              ),
            ),
            Text(
              "scan",
              style: buttonLabelsTextStyle,
            ),
          ],
        ),
        Column(
          children: [
            FloatingActionButton.small(
              backgroundColor: mainTheme.mainColor,
              heroTag: null,
              onPressed: () async {
                toggleFloatingActionButton();
                await widget.onImageProcessing();
              },
              shape: const CircleBorder(),
              child: const Icon(
                Icons.drive_folder_upload,
              ),
            ),
            Text(
              "import",
              style: buttonLabelsTextStyle,
            ),
          ],
        ),
        Column(
          children: [
            FloatingActionButton.small(
              heroTag: null,
              backgroundColor: mainTheme.mainColor,
              onPressed: () async {
                toggleFloatingActionButton();
                print("Create new receipt!!!!!!!!!!");
              },
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            ),
            Text(
              "create",
              style: buttonLabelsTextStyle,
            ),
          ],
        ),
      ],
    );
  }
}
