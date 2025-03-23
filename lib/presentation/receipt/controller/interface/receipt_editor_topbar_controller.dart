import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:save_receipt/services/document/scan/google_barcode_scan.dart';

abstract class ReceiptEditorTopbarController {
  bool get documentFormat;
  bool get isSelectionModeEnabled;
  RxBool get isFormatting;
  RxBool get dataChanged;
  String? get imgPath;
  Uint8List? get barcodeImgBytes;
  Uint8List? get documentImgBytes;
  ReceiptBarcodeData? get barcodeData;

  Future<bool> onReturnAfterChanges();
  Future<void> saveReceipt();
  Future<void> deleteReceipt();

  void openFullImageMode();
  void toggleSelectionMode();
  void handleDocumentFormatting();
}
