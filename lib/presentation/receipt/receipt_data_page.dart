import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/settings/receipt_data_page.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/presentation/receipt/components/data_editor/components/info_editor_list.dart';
import 'package:save_receipt/presentation/receipt/components/data_editor/components/products_editor_list.dart';
import 'package:save_receipt/presentation/receipt/components/receipt_image_viewer.dart';
import 'package:save_receipt/presentation/receipt/components/data_editor/data_editor.dart';
import 'package:save_receipt/presentation/receipt/components/data_editor/data_editor_top_bar.dart';
import 'package:save_receipt/presentation/receipt/components/topbar/top_bar.dart';
import 'package:save_receipt/presentation/receipt/controller/adapters/info_editor_list_controller_adapter.dart';
import 'package:save_receipt/presentation/receipt/controller/adapters/products_editor_list_controller_adapter.dart';
import 'package:save_receipt/presentation/receipt/controller/interface/info_editor_list_controller.dart';
import 'package:save_receipt/presentation/receipt/controller/interface/products_editor_list_controller.dart';
import 'package:save_receipt/presentation/receipt/controller/receipt_editor_page_controller.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/services/document/scan/google_barcode_scan.dart';

class ReceiptDataPage extends StatelessWidget {
  final String title = 'Fill Receipt Data';
  final ReceiptModel initialReceipt;
  final AllValuesModel? allValuesModel;
  final ReceiptBarcodeData? barcodeData;
  late final ReceiptEditorPageController controller;
  late final ProductsEditorListController productsListController;
  late final InfoEditorListController infoListController;

  final themeController = Get.find<ThemeController>();
  final _productListKey = UniqueKey();
  final _infoListKey = UniqueKey();

  ReceiptDataPage({
    required this.initialReceipt,
    this.allValuesModel,
    this.barcodeData,
    super.key,
  }) {
    controller = Get.put(ReceiptEditorPageController(
        receipt: initialReceipt, allValuesModel: allValuesModel));
    productsListController =
        ProductsEditorListControllerAdapter(controller: controller);
    infoListController =
        InfoEditorListControllerAdapter(controller: controller);
  }

  Widget get productsList => ProductsEditorList(
        key: _productListKey,
        controller: productsListController,
      );

  Widget get infosList => InfoEditorList(
        key: _infoListKey,
        controller: infoListController,
      );

  get background {
    return Column(
      children: [
        Container(
          height: ReceiptEditorSettings.backgroundGradientHeigth,
          decoration: BoxDecoration(
            gradient: themeController.theme.gradient,
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) => ReceiptPageTopBar(
        key: UniqueKey(),
        dataChanged: controller.modelController.dataChanged,
        onImageIconPress: controller.openFullImageMode,
        receiptImgPath: controller.modelController.imgPath,
        onReturnAfterChanges: controller.handleReturnAfterChanges,
        onSaveReceiptOptionPress: controller.modelController.saveReceipt,
        onDeleteReceiptOptionPress: controller.deleteReceipt,
        onSelectModeToggled: controller.toggleSelectionMode,
        selectMode: controller.modelController.isSelectionModeEnabled.value,
        barcodeData: barcodeData,
        onDocumentFormattingOptionPress: controller.handleDocumentFormatting,
        documentFormat: controller.documentFormat.value,
        mainColor: themeController.theme.mainColor,
        barcodeImgBytes: controller.documentFormat.value
            ? controller.formatedBarcodeBytes
            : barcodeData?.imgBytes,
        documentImgBytes: controller.documentFormat.value
            ? controller.formatedDocumentBytes
            : null,
        isFormatting: controller.isFormatting.value,
      );

  Widget _buildObjectsEditor() {
    SelectModeEditorOption changeObjectOption =
        controller.modelController.areProductsEdited.value
            ? SelectModeEditorOption(
                label: 'To Info',
                icon: Icons.info_outline,
                onSelected: controller.changeSelectedProductsToInfo,
              )
            : SelectModeEditorOption(
                label: 'To Products',
                icon: Icons.price_change_outlined,
                onSelected: controller.changeSelectedInfoToProducts,
              );
    return ReceiptDataEditor(
      flex: controller.modelController.areProductsEdited.value ? 3 : 1,
      title: controller.modelController.receiptTitle,
      areProductsEdited: controller.modelController.areProductsEdited.value,
      productsList: productsList,
      infoList: infosList,
      onProductsTabPressed: controller.setProductsEditing,
      onInfoTabPressed: controller.setInfoEditing,
      onAddObject: controller.addEmptyObject,
      selectMode: controller.modelController.isSelectionModeEnabled.value,
      selectModeOptions: [
        changeObjectOption,
        SelectModeEditorOption(
          label: 'To Value',
          icon: Icons.transform,
          onSelected: controller.changeSelectedProductsToValue,
        ),
        SelectModeEditorOption(
          label: 'Remove',
          icon: Icons.delete,
          onSelected: controller.removeSelectedProducts,
        ),
      ],
      onTitleChanged: (String newTitle) {
        controller.modelController.receiptTitle = newTitle;
        controller.modelController.trackChange();
      },
    );
  }

  Widget content(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 32.0,
            left: 16.0,
            right: 16.0,
            bottom: 32.0,
          ),
          child: Column(
            children: [
              _buildTopBar(context),
              _buildObjectsEditor(),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Stack(
          children: [
            background,
            content(context),
            if (controller.showFullScreenReceiptImage.value)
              ReceiptImageViewer(
                imagePath: controller.modelController.imgPath!,
                onExit: () =>
                    controller.showFullScreenReceiptImage.value = false,
                formatedDocumentBytes: controller.documentFormat.value
                    ? controller.formatedDocumentBytes
                    : null,
              )
          ],
        ),
      ),
    );
  }
}
