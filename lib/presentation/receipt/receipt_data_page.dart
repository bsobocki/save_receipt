import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/settings/receipt_data_page.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/presentation/receipt/components/receipt_image_viewer.dart';
import 'package:save_receipt/presentation/receipt/components/data_editor/data_editor.dart';
import 'package:save_receipt/presentation/receipt/components/data_editor/data_editor_top_bar.dart';
import 'package:save_receipt/presentation/receipt/components/topbar/top_bar.dart';
import 'package:save_receipt/presentation/receipt/controller/adapters/products_list_controller_adapter.dart';
import 'package:save_receipt/presentation/receipt/controller/interface/products_lists_controller_interface.dart';
import 'package:save_receipt/presentation/receipt/controller/receipt_editor_page_controller.dart';
import 'package:save_receipt/presentation/receipt/data_field/data_field.dart';
import 'package:save_receipt/presentation/receipt/data_field/info_data_field.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/presentation/receipt/data_field/product_data_field.dart';
import 'package:save_receipt/services/document/scan/google_barcode_scan.dart';

class ReceiptDataPage extends StatelessWidget {
  final String title = 'Fill Receipt Data';
  final ReceiptModel initialReceipt;
  final AllValuesModel? allValuesModel;
  final ReceiptBarcodeData? barcodeData;
  late final ReceiptEditorPageController controller;
  late final ProductsListController productsListController;

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
        ProductsListControllerAdapter(controller: controller);
  }

  Widget get productsList {
    return GetBuilder<ReceiptEditorPageController>(
      builder: (controller) => ListView.builder(
        key: _productListKey,
        itemCount: productsListController.products.length,
        controller: controller.productsScrollController,
        itemBuilder: (context, index) {
          return ProductDataField(
            key: UniqueKey(),
            onChangedData: productsListController.trackChange,
            model: productsListController.products[index],
            allValuesData: productsListController.allValuesData,
            isDarker: (index % 2 == 0),
            onItemDismissSwipe: () => productsListController.remove(index),
            onItemEditModeSwipe: () => productsListController.setEditModeOf(index),
            onChangedToValue: () => productsListController.changeToValue(index),
            onChangedToInfo: () => productsListController.changeToInfo(index),
            mode: productsListController.dataFieldModeOf(index),
            selected: productsListController.isSelected(index),
            onSelected: () => productsListController.toggleSelectionOf(index),
            onLongPress: productsListController.toggleSelectionMode,
          );
        },
      ),
    );
  }

  get infosList {
    return GetBuilder<ReceiptEditorPageController>(
      builder: (controller) => ListView.builder(
        key: _infoListKey,
        itemCount: controller.modelController.infos.length,
        controller: controller.infoScrollController,
        itemBuilder: (context, index) {
          ReceiptObjectModelType type =
              controller.modelController.infoAt(index)!.type;
          VoidCallback? onChangedToProduct;
          if (type == ReceiptObjectModelType.infoDouble) {
            onChangedToProduct =
                () => controller.changeInfoDoubleToProduct(index);
          }
          return InfoDataField(
            key: UniqueKey(),
            onChangedData: controller.modelController.trackChange,
            model: controller.modelController.infoAt(index)!,
            allValuesData: controller.modelController.allValuesModel,
            isDarker: (index % 2 == 0),
            onItemDismissSwipe: () => controller.removeObjectByIndex(index),
            onItemEditModeSwipe: () => controller.setEditModeForObject(index),
            onChangedToValue: () => controller.changeInfoToValue(index),
            onValueToFieldChanged: () => controller.changeValueToInfo(index),
            onValueTypeChanged: (ReceiptObjectModelType type) =>
                controller.changeInfoValueType(type, index),
            onChangedToProduct: onChangedToProduct,
            mode: controller.modelController.isSelectionModeEnabled.value
                ? DataFieldMode.select
                : controller.modelController.isInfoInEditMode(index)
                    ? DataFieldMode.edit
                    : DataFieldMode.normal,
            selected: controller.modelController.isInfoSelected(index),
            onSelected: () => controller.toggleObjectSelection(index),
            onLongPress: controller.toggleSelectionMode,
          );
        },
      ),
    );
  }

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
