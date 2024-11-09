import 'package:flutter/material.dart';
import 'package:save_receipt/color/gradient.dart';
import 'package:save_receipt/components/receipt_image.dart';
import 'package:save_receipt/screen/receipt_data/components/top_bar.dart';
import 'package:save_receipt/screen/receipt_data/data_field/data_field.dart';
import 'package:save_receipt/source/data/structures/data_field.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';

class ReceiptDataPage extends StatefulWidget {
  final String title = 'Fill Receipt Data';
  final Receipt initialReceipt;

  const ReceiptDataPage({required this.initialReceipt, super.key});

  @override
  State<ReceiptDataPage> createState() => _ReceiptDataPageState();
}

class _ReceiptDataPageState extends State<ReceiptDataPage> {
  bool showFullScreenReceiptImage = false;
  late Receipt receipt;
  late AllValuesModel allValues;
  List<DataFieldModel> dataFields = [];

  void handleItemSwipe(
      BuildContext context, DismissDirection direction, int index) {
    final DataFieldModel dataField = dataFields[index];

    if (direction == DismissDirection.endToStart) {
      setState(() {
        dataField.isEditing = !dataField.isEditing;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'set edit mode: ${dataField.text} to ${dataField.isEditing}'),
          backgroundColor: const Color.fromARGB(73, 0, 0, 0),
          dismissDirection: direction,
        ),
      );
    }
  }

  void handleItemDismiss(
      BuildContext context, DismissDirection direction, int index) {
    final DataFieldModel dataField = dataFields[index];

    setState(() {
      dataFields.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('remove: ${dataField.text}'),
        backgroundColor: const Color.fromARGB(73, 0, 0, 0),
        dismissDirection: direction,
      ),
    );
  }

  void initData() {
    allValues = AllValuesModel(
      prices: receipt.pricesStr,
      dates: receipt.datesStr,
      info: receipt.infoStr,
    );

    for (ReceiptObject obj in receipt.objects) {
      String text = obj.text;
      String? value;

      switch (obj.type) {
        case ReceiptObjectType.product:
          value = (obj as ReceiptProduct).price.toString();
          break;

        case ReceiptObjectType.date:
          value = (obj as ReceiptDate).date;
          break;

        case ReceiptObjectType.info:
          value = (obj as ReceiptInfo).info;
          break;
      }

      dataFields.add(
        DataFieldModel(
          type: obj.type,
          text: text,
          value: value,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    receipt = widget.initialReceipt;
    initData();
  }

  get topBarHeight => 200.0;

  get dataFieldsList {
    return ListView.builder(
      itemCount: dataFields.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) =>
              handleItemDismiss(context, direction, index),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              return true;
            } else if (direction == DismissDirection.endToStart) {
              handleItemSwipe(context, direction, index);
            }
            return false;
          },
          background: Container(
            decoration: BoxDecoration(
              gradient: redTransparentGradient,
            ),
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Icon(Icons.highlight_remove_outlined),
            ),
          ),
          secondaryBackground: Container(
            decoration: BoxDecoration(
              gradient: transparentGoldGradient,
            ),
            alignment: Alignment.centerRight,
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
              child: Icon(Icons.edit),
            ),
          ),
          child: DataField(
              model: dataFields[index],
              allValues: allValues,
              isDarker: (index % 2 == 0)),
        );
      },
    );
  }

  get background {
    return Column(
      children: [
        Container(
          height: 320,
          decoration: const BoxDecoration(
            gradient: mainGradient,
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
    if (receipt.imgPath != null) {
      setState(() {
        showFullScreenReceiptImage = true;
      });
    } else {
      print("no - image");
    }
  }

  get content {
    return Center(
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
              receiptImgPath: receipt.imgPath,
            ),
            receiptEditor,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screenElements = [
      background,
      content,
    ];

    if (showFullScreenReceiptImage) {
      screenElements.add(
        ReceiptImageViewer(
          imagePath: receipt.imgPath!,
          onExit: () {
            setState(() {
              showFullScreenReceiptImage = false;
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
