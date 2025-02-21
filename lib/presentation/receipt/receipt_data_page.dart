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
  ScrollController _productsScrollController = ScrollController();
  ScrollController _infoScrollController = ScrollController();
  late ReceiptModelController modelController;
  final Key _productListKey = UniqueKey();
  final Key _infoListKey = UniqueKey();

  void _resetScrollControllers() {
    _productsScrollController.dispose();
    _infoScrollController.dispose();

    _productsScrollController = ScrollController();
    _infoScrollController = ScrollController();
  }

  void _scrollToBottom(ScrollController controller) {
    if (controller.hasClients) {
      double distance = controller.position.maxScrollExtent - controller.offset;
      void scroll(_) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: Duration(milliseconds: ((distance + 1) * 2).toInt()),
          curve: Curves.easeOut,
        );
      }
      WidgetsBinding.instance.addPostFrameCallback(scroll);
      
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

  Future<bool> handleReturnAfterChanges() async {
    bool closePage = true;
    await showAlertDialog(
      title: "Save Receipt",
      content: "Do you want to save receipt?",
      actions: [
        TextButton(
          onPressed: () async {
            await modelController.saveReceipt();
            if (mounted) Navigator.pop(context);
          },
          child: const Text("Yes"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () {
            closePage = false;
            Navigator.pop(context);
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
    }
  }

  @override
  void initState() {
    super.initState();
    modelController = ReceiptModelController(
        receipt: widget.initialReceipt, allValuesModel: widget.allValuesModel);
    if (widget.initialReceipt.receiptId == null) {
      modelController.trackChange();
    }
  }

  @override
  void dispose() {
    _productsScrollController.dispose();
    _infoScrollController.dispose();
    super.dispose();
  }

  Widget get productsList {
    return ListView.builder(
      key: _productListKey,
      itemCount: modelController.products.length,
      controller: _productsScrollController,
      itemBuilder: (context, index) {
        return ProductDataField(
          key: UniqueKey(),
          onChangedData: modelController.trackChange,
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
            modelController.toggleObjectSelection(index);
          }),
          onLongPress: toggleSelectMode,
        );
      },
    );
  }

  get infosList {
    return ListView.builder(
      key: _infoListKey,
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
            modelController.toggleObjectSelection(index);
          }),
          onLongPress: toggleSelectMode,
        );
      },
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
          areProductsEdited: modelController.areProductsEdited,
          productsList: productsList,
          infoList: infosList,
          onProductsTabPressed: setProductsEditing,
          onInfoTabPressed: setInfoEditing,
          onAddObject: addEmptyObject,
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
            ),
            SelectModeEditorOption(
              label: 'Remove',
              icon: Icons.delete,
              onSelected: removeSelectedProducts,
            ),
          ]);

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

  void removeSelectedInfo() =>
      setState(() => modelController.removeSelectedObjects());

  void removeSelectedProducts() =>
      setState(() => modelController.removeSelectedObjects());

  void changeInfoValueType(ReceiptObjectModelType type, int index) =>
      setState(() => modelController.changeInfoValueType(type, index));

  void changeSelectedInfoValueType(ReceiptObjectModelType type) =>
      setState(() => modelController.changeSelectedInfoValueType(type));

  void changeInfoToValue(int index) =>
      setState(() => modelController.changeObjectToValue(index));

  void changeSelectedInfoToValue() =>
      setState(() => modelController.changeSelectedObjectsToValue());

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
    bool status = modelController.changeSelectedObjectsToProducts();
    if (!status) {
      await showAlertDialog(
          title: "Changing Info to Product",
          content: "Info value must exists as a price!");
    }
    setState(() {});
  }

  void changeProductToValue(int index) =>
      setState(() => modelController.changeObjectToValue(index));

  void changeSelectedProductsToValue() =>
      setState(() => modelController.changeSelectedObjectsToValue());

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
      setState(() => modelController.removeObjectByIndex(index));

  void handleProductDismiss(int index) =>
      setState(() => modelController.removeObjectByIndex(index));

  void setProductsEditing() => setState(() {
        modelController.setProductsEditing();
        _resetScrollControllers();
      });

  void setInfoEditing() => setState(() {
        modelController.setInfoEditing();
        _resetScrollControllers();
      });

  void addEmptyObject() {
    setState(() => modelController.addEmptyObject());
    _scrollToBottom(
      modelController.areProductsEdited
          ? _productsScrollController
          : _infoScrollController,
    );
  }
}
