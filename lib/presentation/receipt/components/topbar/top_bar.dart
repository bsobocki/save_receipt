import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:save_receipt/core/settings/receipt_data_page.dart';
import 'package:save_receipt/presentation/receipt/components/topbar/navigation_topbar.dart';
import 'package:save_receipt/presentation/receipt/components/topbar/receipt_img_view.dart';
import 'package:save_receipt/services/document/scan/google_barcode_scan.dart';

class ReceiptPageTopBar extends StatelessWidget {
  final Function() onSaveReceiptOptionPress;
  final Function() onDeleteReceiptOptionPress;
  final Function() onSelectModeToggled;
  final VoidCallback onImageIconPress;
  final String? receiptImgPath;
  final RxBool dataChanged;
  final Future<bool> Function() onReturnAfterChanges;
  final bool selectMode;
  final ReceiptBarcodeData? barcodeData;
  final VoidCallback onDocumentFormattingOptionPress;
  final bool documentFormat;
  final Uint8List? documentImgBytes;
  final Uint8List? barcodeImgBytes;
  final Color mainColor;
  final bool isFormatting;

  const ReceiptPageTopBar({
    super.key,
    required this.onImageIconPress,
    this.receiptImgPath,
    required this.onSaveReceiptOptionPress,
    required this.onDeleteReceiptOptionPress,
    required this.dataChanged,
    required this.onReturnAfterChanges,
    required this.onSelectModeToggled,
    required this.selectMode,
    this.barcodeData,
    required this.onDocumentFormattingOptionPress,
    required this.documentFormat,
    this.documentImgBytes,
    this.barcodeImgBytes,
    required this.mainColor,
    required this.isFormatting,
  });

  Widget expandedPlaceholder({int flex = 1}) =>
      Expanded(flex: flex, child: Container());

  Widget get emptyVerticalSpace =>
      const SizedBox(height: ReceiptEditorSettings.topBarSpaceHeight);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NavigationTopbar(
            selectMode: selectMode,
            documentFormat: documentFormat,
            mainColor: mainColor,
            dataChanged: dataChanged,
            onReturnAfterChanges: onReturnAfterChanges,
            onSaveReceiptOptionPress: onSaveReceiptOptionPress,
            onDeleteReceiptOptionPress: onDeleteReceiptOptionPress,
            onSelectModeToggled: onSelectModeToggled,
            onDocumentFormattingOptionPress: onDocumentFormattingOptionPress),
        emptyVerticalSpace,
        ReceiptImageView(
          mainColor: mainColor,
          barcodeData: barcodeData,
          barcodeImgBytes: barcodeImgBytes,
          documentImgBytes: documentImgBytes,
          isFormatting: isFormatting,
          receiptImgPath: receiptImgPath,
          onImageIconPress: onImageIconPress,
        ),
      ],
    );
  }
}
