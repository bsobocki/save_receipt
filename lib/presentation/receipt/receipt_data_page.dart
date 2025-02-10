import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/settings/receipt_data_page.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/presentation/common/widgets/receipt_image.dart';
import 'package:save_receipt/presentation/receipt/components/data_editor/data_editor.dart';
import 'package:save_receipt/presentation/receipt/components/data_editor/data_editor_top_bar.dart';
import 'package:save_receipt/presentation/receipt/components/top_bar.dart';
import 'package:save_receipt/presentation/receipt/data_field/data_field.dart';
import 'package:save_receipt/presentation/receipt/data_field/info_data_field.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/presentation/receipt/controller/receipt_controller.dart';
import 'package:save_receipt/presentation/receipt/data_field/product_data_field.dart';

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
  final ThemeController themeController = Get.find();
  final ScrollController _productsScrollController = ScrollController();
  final ScrollController _infoScrollController = ScrollController();
  late ReceiptModelController modelController;

  void _scrollToBottom(ScrollController controller) {
    if (controller.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> handleReceiptDeleted() async {
    try {
      await modelController.deleteReceipt();
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
  }

  Future<void> handleReturnAfterChanges() async => await showAlertDialog(
        title: "Save Receipt",
        content: "Do you want to save receipt?",
        actions: [
          TextButton(
            onPressed: () async {
              await modelController.saveReceipt();
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          )
        ],
      );

  Future<void> showAlertDialog({
    required String title,
    required String content,
    List<Widget>? actions,
  }) async {
    actions ??= [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("OK"),
      ),
    ];

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
        );
      },
    );
  }

  void openFullImageMode() {
    if (modelController.imgPathExists) {
      setState(() {
        _showFullScreenReceiptImage = true;
      });
    } else {
      print("no - image");
    }
  }

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
        controller: _productsScrollController,
        itemBuilder: (context, index) {
          return ProductDataField(
            key: UniqueKey(),
            onChangedData: modelController.trackChange,
            enabled: modelController.areProductsEdited,
            model: modelController.productAt(index)!,
            allValuesData: modelController.allValuesModel,
            isDarker: (index % 2 == 0),
            onItemDismissSwipe: () => handleProductDismiss(index),
            onItemEditModeSwipe: () => setEditModeForProduct(index),
            onChangedToValue: () => changeProductToValue(index),
            onChangedToInfo: () => changeProductToInfo(index),
            mode: modelController.isSelectModeEnabled
                ? DataFieldMode.select
                : modelController.isProductInEditMode(index)
                    ? DataFieldMode.edit
                    : DataFieldMode.normal,
            selected: modelController.isProductSelected(index),
            onSelected: () => setState(() {
              modelController.toggleProductSelection(index);
            }),
          );
        },
      ),
    );
  }

  get infosList {
    return Expanded(
      child: ListView.builder(
        itemCount: modelController.infos.length,
        controller: _infoScrollController,
        itemBuilder: (context, index) {
          ReceiptObjectModelType type = modelController.infoAt(index)!.type;
          VoidCallback? onChangedToProduct;
          if (type == ReceiptObjectModelType.infoDouble) {
            onChangedToProduct = () => changeInfoDoubleToProduct(index);
          }
          return InfoDataField(
            key: UniqueKey(),
            onChangedData: modelController.trackChange,
            enabled: !modelController.areProductsEdited,
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
            mode: modelController.isSelectModeEnabled
                ? DataFieldMode.select
                : modelController.isInfoInEditMode(index)
                    ? DataFieldMode.edit
                    : DataFieldMode.normal,
            selected: modelController.isInfoSelected(index),
            onSelected: () => setState(() {
              modelController.toggleInfoSelection(index);
            }),
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

  Widget topBar(BuildContext context) => ReceiptPageTopBar(
        dataChanged: modelController.dataChangedNotifier,
        onImageIconPress: openFullImageMode,
        receiptImgPath: modelController.imgPath,
        //barcodeImgPaht: _receipt.barcodePath,
        onReturnAfterChanges: handleReturnAfterChanges,
        onSaveReceiptOptionPress: modelController.saveReceipt,
        onDeleteReceiptOptionPress: handleReceiptDeleted,
        onSelectModeToggled: toggleSelectMode,
        selectMode: modelController.isSelectModeEnabled,
      );

  get productsEditor => ReceiptDataEditor(
          flex: modelController.areProductsEdited ? 3 : 1,
          title: "Products",
          isExpanded: modelController.areProductsEdited,
          objectsList: productsList,
          onResized: setProductsEditing,
          onAddObject: addEmptyProduct,
          selectMode: modelController.isSelectModeEnabled,
          selectModeOptions: [
            SelectModeEditorOption(
              label: 'To Info',
              icon: Icons.info_outline,
              onSelected: changeSelectedProductsToInfo,
            ),
            SelectModeEditorOption(
              label: 'To Value',
              icon: Icons.transform,
              onSelected: changeSelectedProductsToValue,
            )
          ]);

  get infoEditor => ReceiptDataEditor(
        flex: modelController.areProductsEdited ? 1 : 3,
        title: "Info",
        isExpanded: !modelController.areProductsEdited,
        selectMode: modelController.isSelectModeEnabled,
        objectsList: infosList,
        onResized: setInfoEditing,
        onAddObject: addEmptyInfo,
        selectModeOptions: [
          SelectModeEditorOption(
            label: 'To Product',
            icon: Icons.info_outline,
            onSelected: changeSelectedInfoToProducts,
          ),
          SelectModeEditorOption(
            label: 'To Value',
            icon: Icons.transform,
            onSelected: changeSelectedInfoToValue,
          ),
        ],
      );

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
              topBar(context),
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
      content(context),
    ];

    print("SELECTION MODE? ${modelController.isSelectModeEnabled}");

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

  void toggleSelectMode() => setState(() => modelController.toggleSelectMode());

  void changeInfoValueType(ReceiptObjectModelType type, int index) =>
      setState(() => modelController.changeInfoValueType(type, index));

  void changeSelectedInfoValueType(ReceiptObjectModelType type) =>
      setState(() => modelController.changeSelectedInfoValueType(type));

  void changeInfoToValue(int index) =>
      setState(() => modelController.changeInfoToValue(index));

  void changeSelectedInfoToValue() =>
      setState(() => modelController.changeSelectedInfoToValue());

  void changeInfoDoubleToProduct(int index) async {
    bool status = modelController.changeInfoDoubleToProduct(index);
    if (!status) {
      await showAlertDialog(
          title: "Changing Info to Product",
          content: "Info value must exists as a price!");
    }
    setState(() {});
  }

  void changeSelectedInfoToProducts() async {
    bool status = modelController.changeSelectedInfoToProducts();
    if (!status) {
      await showAlertDialog(
          title: "Changing Info to Product",
          content: "Info value must exists as a price!");
    }
    setState(() {});
  }

  void changeProductToValue(int index) =>
      setState(() => modelController.changeProductToValue(index));

  void changeSelectedProductsToValue() =>
      setState(() => modelController.changeSelectedProductsToValue());

  void changeProductToInfo(int index) =>
      setState(() => modelController.changeProductToInfoDouble(index));

  void changeSelectedProductsToInfo() =>
      setState(() => modelController.changeSelectedProductsToInfo());

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

  void setProductsEditing() =>
      setState(() => modelController.setProductsEditing());

  void setInfoEditing() => setState(() => modelController.setInfoEditing());

  void addEmptyProduct() {
    setState(() => modelController.addEmptyProduct());
    _scrollToBottom(_productsScrollController);
  }

  void addEmptyInfo() {
    setState(() => modelController.addEmptyInfo());
    _scrollToBottom(_infoScrollController);
  }
}
