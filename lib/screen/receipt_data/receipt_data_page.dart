import 'package:flutter/material.dart';
import 'package:save_receipt/color/themes/main_theme.dart';
import 'package:save_receipt/components/receipt_image.dart';
import 'package:save_receipt/screen/receipt_data/components/top_bar.dart';
import 'package:save_receipt/screen/receipt_data/data_field/data_field.dart';
import 'package:save_receipt/source/data/structures/data_field.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';
import 'package:save_receipt/source/data/controller/receipt_model_controller.dart';

class ReceiptDataPage extends StatefulWidget {
  final String title = 'Fill Receipt Data';
  final ReceiptModel initialReceipt;

  const ReceiptDataPage({required this.initialReceipt, super.key});

  @override
  State<ReceiptDataPage> createState() => _ReceiptDataPageState();
}

class _ReceiptDataPageState extends State<ReceiptDataPage> {
  bool _showFullScreenReceiptImage = false;
  final ScrollController _scrollController = ScrollController();
  late ReceiptModelController modelController;

  void changeItemToValue(int index) => setState(() {
        modelController.changeItemToValue(index);
      });

  void changeValueToItem(int index) => setState(() {
        modelController.changeValueToItem(index);
      });

  void handleItemSwipe(
      BuildContext context, DismissDirection direction, int index) {
    if (direction == DismissDirection.endToStart) {
      handleItemEditMode(context, index);
    } else if (direction == DismissDirection.startToEnd) {
      handleItemDismiss(context, index);
    }
  }

  void handleItemEditMode(BuildContext context, int index) {
    setState(() => modelController.toggleEditModeOfDataField(index));

    final DataFieldModel? dataField = modelController.dataFieldAt(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('set edit mode: ${dataField?.text} to ${dataField?.isEditing}'),
        backgroundColor: const Color.fromARGB(73, 0, 0, 0),
      ),
    );
  }

  void handleItemDismiss(BuildContext context, int index) {
    setState(() => modelController.removeDataField(index));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('remove: ${modelController.dataFieldAt(index)?.text}'),
        backgroundColor: const Color.fromARGB(73, 0, 0, 0),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    modelController = ReceiptModelController(widget.initialReceipt);
  }

  get dataFieldsList {
    return ListView.builder(
      itemCount: modelController.dataFields.length,
      controller: _scrollController,
      itemBuilder: (context, index) {
        return DataField(
          key: UniqueKey(),
          model: modelController.dataFieldAt(index)!,
          allValuesData: modelController.allValuesModel,
          isDarker: (index % 2 == 0),
          onItemDismissSwipe: () =>
              handleItemSwipe(context, DismissDirection.startToEnd, index),
          onItemEditModeSwipe: () =>
              handleItemSwipe(context, DismissDirection.endToStart, index),
          onChangeToValue: () => changeItemToValue(index),
          onValueToFieldChange: () => changeValueToItem(index),
        );
      },
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

  get receiptEditor => Expanded(
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
            child: dataFieldsList,
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
              ReceiptPageTopBar(
                onImageIconPress: openFullImageMode,
                receiptImgPath: modelController.imgPath,
                //barcodeImgPaht: _receipt.barcodePath,
              ),
              receiptEditor,
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
