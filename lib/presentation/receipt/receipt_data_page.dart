import 'package:flutter/material.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/presentation/common/widgets/receipt_image.dart';
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
  late ReceiptModelController modelController;

  void changeInfoToValue(int index) => setState(() {
        modelController.changeInfoToValue(index);
      });

  void changeValueToInfo(int index) => setState(() {
        modelController.changeValueToInfo(index);
      });

  void handleItemSwipe(
      BuildContext context, DismissDirection direction, int index) {
    if (direction == DismissDirection.endToStart) {
      handleInfoEditMode(index);
    } else if (direction == DismissDirection.startToEnd) {
      handleInfoDismiss(context, index);
    }
  }

  void handleInfoEditMode(int index) =>
      setState(() => modelController.toggleEditModeOfInfo(index));

  void handleInfoDismiss(BuildContext context, int index) =>
      setState(() => modelController.removeDataField(index));

  @override
  void initState() {
    super.initState();
    modelController = ReceiptModelController(widget.initialReceipt, widget.allValuesModel);
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
            onItemDismissSwipe: () {},
            onItemEditModeSwipe: () {},
            onChangeToValue: () {},
            onValueToFieldChange: () {},
            onValueTypeChanged: (ReceiptObjectModelType type) {},
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
          return DataField(
            key: UniqueKey(),
            model: modelController.infoAt(index)!,
            allValuesData: modelController.allValuesModel,
            isDarker: (index % 2 == 0),
            onItemDismissSwipe: () =>
                handleItemSwipe(context, DismissDirection.startToEnd, index),
            onItemEditModeSwipe: () =>
                handleItemSwipe(context, DismissDirection.endToStart, index),
            onChangeToValue: () => changeInfoToValue(index),
            onValueToFieldChange: () => changeValueToInfo(index),
            onValueTypeChanged: (ReceiptObjectModelType type) =>
                modelController.changeInfoValueType(type, index),
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
            gradient: mainTheme.gradient,
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

  get productsEditor => Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: mainTheme.mainColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15.0)),
                  ),
                  width: double.infinity,
                  height: 30.0,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Text(
                      "Products:",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                productsList,
              ],
            ),
          ),
        ),
      );

  get infoEditor => Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: mainTheme.mainColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15.0)),
                  ),
                  width: double.infinity,
                  height: 30.0,
                  child: const Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: const Text(
                      "Additional Info:",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                infosList,
              ],
            ),
          ),
        ),
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
