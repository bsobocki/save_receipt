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
  State<ExpandableFloatingActionButton> createState() =>
      _ExpandableFloatingActionButtonState();
}

class _ExpandableFloatingActionButtonState
    extends State<ExpandableFloatingActionButton> {
  final _expandableFabKey = GlobalKey<ExpandableFabState>();

  final ThemeController themeController = Get.find();

  void toggleFloatingActionButton() {
    if (_expandableFabKey.currentState != null) {
      _expandableFabKey.currentState!.toggle();
    }
  }

  Widget _buildOptionButton({
    required String label,
    required Function() onPressed,
    required Widget icon,
  }) =>
      Column(
        children: [
          FloatingActionButton.small(
            heroTag: null,
            backgroundColor: themeController.theme.mainColor,
            onPressed: () async {
              toggleFloatingActionButton();
              await onPressed();
            },
            shape: const CircleBorder(),
            child: icon,
          ),
          Text(
            label,
            style: TextStyle(
              color: themeController.theme.mainColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      key: _expandableFabKey,
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
        _buildOptionButton(
          label: 'scan',
          onPressed: widget.onDocumentScanning,
          icon: Image.asset(
            'assets/googleScannerIcon.png',
            height: 24,
            width: 24,
          ),
        ),
        _buildOptionButton(
          label: 'import',
          onPressed: widget.onImageProcessing,
          icon: const Icon(Icons.drive_folder_upload),
        ),
        _buildOptionButton(
          label: 'create',
          onPressed: widget.onNewReceiptAdding,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
