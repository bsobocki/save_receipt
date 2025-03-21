import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/presentation/receipt/controller/receipt_model_controller.dart';
import 'package:save_receipt/services/document/scan/google_barcode_scan.dart';
import 'package:save_receipt/services/images/edit_image.dart';

class ReceiptEditorPageController extends GetxController {
  final RxBool showFullScreenReceiptImage = false.obs;
  final RxBool documentFormat = false.obs;
  final RxBool isFormatting = false.obs;

  final themeController = Get.find<ThemeController>();
  ScrollController productsScrollController = ScrollController();
  ScrollController infoScrollController = ScrollController();
  final ReceiptModelController modelController;
  Uint8List? formatedDocumentBytes;
  Uint8List? formatedBarcodeBytes;
  final ReceiptBarcodeData? barcodeData;

  ReceiptEditorPageController({
    required final ReceiptModel receipt,
    this.barcodeData,
    AllValuesModel? allValuesModel,
  }) : modelController = ReceiptModelController(
            receipt: receipt, allValuesModel: allValuesModel) {
    if (receipt.receiptId == null) {
      modelController.trackChange();
    }
  }

  void _showAlert(
      {required String title,
      String middleText = '',
      String textConfirm = "OK"}) {
    Get.defaultDialog(
      title: title,
      middleText: middleText,
      textConfirm: textConfirm,
      confirmTextColor: themeController.theme.mainColor,
      onConfirm: () => Get.back(),
    );
  }

  void scrollToBottom(ScrollController controller) {
    if (controller.hasClients) {
      double distance = controller.position.maxScrollExtent - controller.offset;
      int duration = ((distance + 1) * 1.5).toInt();
      duration = duration.clamp(300, 2000);
      void scroll(_) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: Duration(milliseconds: duration),
          curve: Curves.easeOut,
        );
      }

      WidgetsBinding.instance.addPostFrameCallback(scroll);
    }
  }

  Future<void> deleteReceipt() async {
    try {
      await showAlertDialog(
          title: 'Delete Receipt',
          content: "Do you want to delete this receipt?",
          actions: [
            TextButton(
              onPressed: () async {
                await modelController.deleteReceipt();
                Get.back();
                Get.back();
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('No'),
            ),
          ]);
    } catch (e) {
      _showAlert(
          title: 'Failed to delete receipt',
          middleText: 'Failed to delete receipt: ${e.toString()}');
    }
  }

  Future<bool> handleReturnAfterChanges() async {
    bool closePage = true;
    await showAlertDialog(
      title: "Save Receipt",
      content: "Do you want to save receipt?",
      actions: [
        TextButton(
          onPressed: () async {
            await modelController.saveReceipt();
            Get.back();
          },
          child: const Text("Yes"),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () {
            closePage = false;
            Get.back();
          },
          child: const Text("Cancel"),
        )
      ],
    );
    return closePage;
  }

  Future<void> showAlertDialog({
    required String title,
    required String content,
    List<Widget>? actions,
  }) async {
    actions ??= [
      TextButton(
        onPressed: () => Get.back(),
        child: const Text("OK"),
      ),
    ];

    await Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: themeController.theme.mainColor,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            color: themeController.theme.mainColor,
          ),
        ),
        actions: actions,
      ),
    );
  }

  @override
  void dispose() {
    productsScrollController.dispose();
    infoScrollController.dispose();
    super.dispose();
  }

  void openFullImageMode() {
    if (modelController.imgPathExists) {
      showFullScreenReceiptImage.value = true;
    }
  }

  void _resetScrollControllers() {
    if (productsScrollController.hasClients) {
      productsScrollController.jumpTo(0);
    }

    if (infoScrollController.hasClients) {
      infoScrollController.jumpTo(0);
    }
  }

  void handleDocumentFormatting() async {
    if (!documentFormat.value && formatedDocumentBytes == null) {
      processDocumentFormatting();
    }
    documentFormat.value = !documentFormat.value;
  }

  void processDocumentFormatting() async {
    isFormatting.value = true;
    if (modelController.imgPath != null) {
      formatedDocumentBytes =
          await compute(adjustDocumentFile, modelController.imgPath!);
      formatedBarcodeBytes =
          await compute(adjustDocumentBytes, barcodeData?.imgBytes);
    }
    isFormatting.value = false;
  }

  void toggleSelectionMode() => modelController.toggleSelectionMode();
  void toggleObjectSelection(int index) {
    modelController.toggleObjectSelection(index);
    update();
  }

  void removeSelectedInfo() {
    modelController.removeSelectedObjects();
    update();
  }

  void removeSelectedProducts() {
    modelController.removeSelectedObjects();
    update();
  }

  void changeInfoValueType(ReceiptObjectModelType type, int index) {
    modelController.changeInfoValueType(type, index);

    update();
  }

  void changeSelectedInfoValueType(ReceiptObjectModelType type) {
    modelController.changeSelectedInfoValueType(type);
    update();
  }

  void changeInfoToValue(int index) {
    modelController.changeObjectToValue(index);
    update();
  }

  void changeSelectedInfoToValue() {
    modelController.changeSelectedObjectsToValue();
    update();
  }

  void changeInfoDoubleToProduct(int index) async {
    bool status = modelController.changeInfoDoubleToProduct(index);
    if (!status) {
      await showAlertDialog(
          title: "Changing Info to Product",
          content: "Info value must exists as a price!");
    }
    update();
  }

  void changeSelectedInfoToProducts() async {
    bool status = modelController.changeSelectedInfoToProducts();
    if (!status) {
      await showAlertDialog(
          title: "Changing Info to Product",
          content: "Info value must exists as a price!");
    }
    update();
  }

  void changeProductToValue(int index) {
    modelController.changeObjectToValue(index);
    update();
  }

  void changeSelectedProductsToValue() {
    modelController.changeSelectedObjectsToValue();
    update();
  }

  void changeProductToInfo(int index) {
    modelController.changeProductToInfoDouble(index);
    update();
  }

  void changeSelectedProductsToInfo() {
    modelController.changeSelectedProductsToInfo();
    update();
  }

  void changeValueToInfo(int index) {
    modelController.changeValueToInfo(index);
    update();
  }

  void setEditModeForObject(int index) {
    modelController.setEditModeForObject(index);
    update();
  }

  void removeObjectByIndex(int index) {
    modelController.removeObjectByIndex(index);
    update();
  }

  void setProductsEditing() {
    modelController.setProductsEditing();
    _resetScrollControllers();
  }

  void setInfoEditing() {
    modelController.setInfoEditing();
    _resetScrollControllers();
  }

  void addEmptyObject() {
    modelController.addEmptyObject();
    scrollToBottom(
      modelController.areProductsEdited.value
          ? productsScrollController
          : infoScrollController,
    );
    update();
  }
}
