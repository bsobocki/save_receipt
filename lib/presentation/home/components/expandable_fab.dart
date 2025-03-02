import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
export 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:save_receipt/core/themes/main_theme.dart';

class ExpandableFloatingActionButton extends StatefulWidget {
  const ExpandableFloatingActionButton({
    super.key,
    required this.onNewReceiptAdding,
    required this.onImageProcessing,
    required this.onDocumentScanning,
  });

  final VoidCallback onNewReceiptAdding;
  final Future<void> Function() onImageProcessing;
  final Future<void> Function() onDocumentScanning;

  @override
  State<ExpandableFloatingActionButton> createState() => _ExpandableFloatingActionButtonState();
}

class _ExpandableFloatingActionButtonState extends State<ExpandableFloatingActionButton> {
  final _expandableFabKey = GlobalKey<ExpandableFabState>();

  final ThemeController themeController = Get.find();

  void toggleFloatingActionButton() {
    if (_expandableFabKey.currentState != null) {
      _expandableFabKey.currentState!.toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle buttonLabelsTextStyle = TextStyle(
        color: themeController.theme.mainColor, fontWeight: FontWeight.w800);
    return ExpandableFab(
      key: _expandableFabKey,
      // type: ExpandableFabType.fan,
      pos: ExpandableFabPos.right,
      distance: 120,
      fanAngle: 90,
      openCloseStackAlignment: Alignment.bottomCenter,
      overlayStyle: ExpandableFabOverlayStyle(
        blur: 1.0,
        color: themeController.theme.extraLightMainColor.withOpacity(0.2),
      ),
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.receipt_sharp),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.white,
        backgroundColor: themeController.theme.mainColor,
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.close),
        fabSize: ExpandableFabSize.regular,
        backgroundColor: themeController.theme.extraLightMainColor,
        foregroundColor: themeController.theme.mainColor,
        shape: const CircleBorder(),
      ),
      children: [
        Column(
          children: [
            FloatingActionButton.small(
              heroTag: null,
              backgroundColor: themeController.theme.mainColor,
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
              backgroundColor: themeController.theme.mainColor,
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
              backgroundColor: themeController.theme.mainColor,
              onPressed: () async {
                toggleFloatingActionButton();
                widget.onNewReceiptAdding();
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
