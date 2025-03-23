import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/settings/receipt_data_page.dart';
import 'package:save_receipt/presentation/receipt/components/topbar/navigation_topbar.dart';
import 'package:save_receipt/presentation/receipt/components/topbar/receipt_img_view.dart';
import 'package:save_receipt/presentation/receipt/controller/interface/receipt_editor_topbar_controller.dart';

class ReceiptPageTopBar extends StatelessWidget {
  final Color mainColor;
  final ReceiptEditorTopbarController controller;

  const ReceiptPageTopBar({
    super.key,
    required this.mainColor,
    required this.controller,
  });

  Widget get emptyVerticalSpace =>
      const SizedBox(height: ReceiptEditorSettings.topBarSpaceHeight);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NavigationTopbar(
            selectionMode: controller.isSelectionModeEnabled,
            documentFormat: controller.documentFormat,
            mainColor: mainColor,
            dataChanged: controller.dataChanged,
            onReturnAfterChanges: controller.onReturnAfterChanges,
            onSaveReceiptOptionPress: controller.saveReceipt,
            onDeleteReceiptOptionPress: controller.deleteReceipt,
            onSelectionModeToggled: controller.toggleSelectionMode,
            onDocumentFormattingOptionPress:
                controller.handleDocumentFormatting,
          ),
          emptyVerticalSpace,
          ReceiptImageView(
            mainColor: mainColor,
            barcodeData: controller.barcodeData,
            barcodeImgBytes: controller.barcodeImgBytes,
            documentImgBytes: controller.documentImgBytes,
            isFormatting: controller.isFormatting.value,
            receiptImgPath: controller.imgPath,
            onImageIconPress: controller.openFullImageMode,
          ),
        ],
      ),
    );
  }
}
