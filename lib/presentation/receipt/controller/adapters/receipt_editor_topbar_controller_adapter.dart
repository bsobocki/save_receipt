import 'dart:typed_data';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:save_receipt/presentation/receipt/controller/interface/receipt_editor_topbar_controller.dart';
import 'package:save_receipt/presentation/receipt/controller/receipt_editor_page_controller.dart';
import 'package:save_receipt/services/document/scan/google_barcode_scan.dart';

class ReceiptEditorTopbarControllerAdapter
    implements ReceiptEditorTopbarController {
  final ReceiptEditorPageController controller;
  final ReceiptBarcodeData? receiptBarcodeData;

  ReceiptEditorTopbarControllerAdapter({
    required this.controller,
    this.receiptBarcodeData,
  });

  @override
  RxBool get dataChanged => controller.modelController.dataChanged;

  @override
  bool get documentFormat => controller.documentFormat.value;

  @override
  String? get imgPath => controller.modelController.imgPath;

  @override
  bool get isFormatting => controller.isFormatting.value;
  
  @override
  bool get isSelectionModeEnabled => controller.modelController.isSelectionModeEnabled.value;

  @override
  Uint8List? get barcodeImgBytes => controller.documentFormat.value
      ? controller.formatedBarcodeBytes
      : barcodeData?.imgBytes;
  
  @override
  Uint8List? get documentImgBytes => controller.documentFormat.value
            ? controller.formatedDocumentBytes
            : null;

  @override
  Future<void> deleteReceipt() async => await controller.deleteReceipt();

  @override
  Future<bool> onReturnAfterChanges() async =>
      await controller.handleReturnAfterChanges();

  @override
  Future<void> saveReceipt() async =>
      await controller.modelController.saveReceipt();

  @override
  void handleDocumentFormatting() => controller.handleDocumentFormatting();

  @override
  void openFullImageMode() => controller.openFullImageMode();

  @override
  void toggleSelectionMode() => controller.toggleSelectionMode();
  
  @override
  ReceiptBarcodeData? get barcodeData => receiptBarcodeData;
}
