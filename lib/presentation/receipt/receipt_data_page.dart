import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/presentation/common/widgets/receipt_image.dart';
import 'package:save_receipt/presentation/receipt/components/data_editor.dart';
import 'package:save_receipt/presentation/receipt/components/top_bar.dart';
import 'package:save_receipt/presentation/receipt/data_field/data_field.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/presentation/receipt/controller/receipt_controller.dart';

class ReceiptDataPage extends StatefulWidget {
  final String title = 'Fill Receipt Data';
  final ReceiptModel initialReceipt;
  final AllValuesModel? allValuesModel;

  const ReceiptDataPage({
    required this.initialReceipt,
    this.allValuesModel,
    super.key,
  });

  @override
  State<ReceiptDataPage> createState() => _ReceiptDataPageState();
}

class _ReceiptDataPageState extends State<ReceiptDataPage> {
  bool _showFullScreenReceiptImage = false;
  final ScrollController _scrollController = ScrollController();
  final ThemeController themeController = Get.find();
  late ReceiptModelController modelController;

  void changeInfoValueType(ReceiptObjectModelType type, int index) =>
      setState(() => modelController.changeInfoValueType(type, index));

  void changeInfoToValue(int index) =>
      setState(() => modelController.changeInfoToValue(index));

  void changeProductToValue(int index) =>
      setState(() => modelController.changeProductToValue(index));

  void changeInfoToProduct(int index) =>
      setState(() => modelController.changeInfoToValue(index));

  void changeProductToInfo(int index) =>
      setState(() => modelController.changeProductToInfoDouble(index));

  void changeInfoDoubleToProduct(int index) =>
      setState(() => modelController.changeInfoDoubleToProduct(index));

  void changeValueToInfo(int index) =>
      setState(() => modelController.changeValueToInfo(index));

  void setEditModeForInfo(int index) =>
      setState(() => modelController.setEditModeForInfo(index));

  void setEditModeForProduct(int index) =>
      setState(() => modelController.setEditModeForProduct(index));

  void handleInfoDismiss(int index) =>
      setState(() => modelController.removeInfo(index));

  void handleProductDismiss(int index) =>
      setState(() => modelController.removeProduct(index));

  void toggleObjectsEditing() =>
      setState(() => modelController.toggleObjectsEditing());

  @override
  void initState() {
    super.initState();
    modelController =
        ReceiptModelController(widget.initialReceipt, widget.allValuesModel);
  }

  Widget get productsList {
    return Expanded(
      child: ListView.builder(
        itemCount: modelController.products.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          return DataField(
            key: UniqueKey(),
            model: modelController.productAt(index)!,
            allValuesData: modelController.allValuesModel,
            isDarker: (index % 2 == 0),
            onItemDismissSwipe: () => handleProductDismiss(index),
            onItemEditModeSwipe: () => setEditModeForProduct(index),
            onChangedToValue: () => changeProductToValue(index),
            onChangedToInfo: () => changeProductToInfo(index),
            isInEditMode: modelController.isProductInEditMode(index),
          );
        },
      ),
    );
  }

  get infosList {
    return Expanded(
      child: ListView.builder(
        itemCount: modelController.infos.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          ReceiptObjectModelType type = modelController.infoAt(index)!.type;
          VoidCallback? onChangedToProduct;
          if (type == ReceiptObjectModelType.infoDouble) {
            onChangedToProduct = () => changeInfoDoubleToProduct(index);
          }
          return DataField(
            key: UniqueKey(),
            model: modelController.infoAt(index)!,
            allValuesData: modelController.allValuesModel,
            isDarker: (index % 2 == 0),
            onItemDismissSwipe: () => handleInfoDismiss(index),
            onItemEditModeSwipe: () => setEditModeForInfo(index),
            onChangedToValue: () => changeInfoToValue(index),
            onValueToFieldChanged: () => changeValueToInfo(index),
            onValueTypeChanged: (ReceiptObjectModelType type) =>
                changeInfoValueType(type, index),
            onChangedToProduct: onChangedToProduct,
            isInEditMode: modelController.isInfoInEditMode(index),
          );
        },
      ),
    );
  }

  get background {
    return Column(
      children: [
        Container(
          height: 320,
          decoration: BoxDecoration(
            gradient: themeController.theme.gradient,
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }

  get topBar => ReceiptPageTopBar(
        onImageIconPress: openFullImageMode,
        receiptImgPath: modelController.imgPath,
        //barcodeImgPaht: _receipt.barcodePath,
        onSaveReceipt: () async {
          int receiptId =
              await modelController.saveReceipt(modelController.model);
          modelController.receiptId ??= receiptId;
        },
        onDeleteReceipt: () async {
          try {
            if (modelController.receiptId != null) {
              await modelController.deleteReceipt(modelController.receiptId!);
            }
            if (mounted) {
              Navigator.pop(context);
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to delete receipt: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      );

  get productsEditor => ReceiptDataEditor(
        flex: modelController.areProductsEdited ? 3 : 1,
        title: "Products",
        isExpanded: modelController.areProductsEdited,
        objectsList: productsList,
        onResizeButtonPressed: toggleObjectsEditing,
      );

  get infoEditor => ReceiptDataEditor(
        flex: modelController.areProductsEdited ? 1 : 3,
        title: "Info",
        isExpanded: !modelController.areProductsEdited,
        objectsList: infosList,
        onResizeButtonPressed: toggleObjectsEditing,
      );

  void openFullImageMode() {
    if (modelController.imgPathExists) {
      setState(() {
        _showFullScreenReceiptImage = true;
      });
    } else {
      print("no - image");
    }
  }

  get content => Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 32.0,
            left: 16.0,
            right: 16.0,
            bottom: 32.0,
          ),
          child: Column(
            children: [
              topBar,
              productsEditor,
              infoEditor,
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    List<Widget> screenElements = [
      background,
      content,
    ];

    if (_showFullScreenReceiptImage) {
      screenElements.add(
        ReceiptImageViewer(
          imagePath: modelController.imgPath!,
          onExit: () {
            setState(() {
              _showFullScreenReceiptImage = false;
            });
          },
        ),
      );
    }
    return Scaffold(
      body: Stack(
        children: screenElements,
      ),
    );
  }
}
