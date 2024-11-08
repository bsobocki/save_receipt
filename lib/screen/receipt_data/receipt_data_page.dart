import 'package:flutter/material.dart';
import 'package:save_receipt/color/background/gradient.dart';
import 'package:save_receipt/components/receipt_image.dart';
import 'package:save_receipt/screen/receipt_data/components/top_bar.dart';
import 'package:save_receipt/screen/receipt_data/data_field/data_field.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';

class ReceiptDataPage extends StatefulWidget {
  final String title = 'Fill Receipt Data';
  final Receipt initialReceipt;

  const ReceiptDataPage({required this.initialReceipt, super.key});

  @override
  State<ReceiptDataPage> createState() => _ReceiptDataPageState();
}

class _ReceiptDataPageState extends State<ReceiptDataPage> {
  late Receipt receipt;
  List<DataField> dataFields = [];
  bool showFullScreenReceiptImage = false;

  void initDataFields() {
    for (ReceiptObject obj in receipt.objects) {
      String text = obj.text;
      String? value;
      List<String> values = [];

      switch (obj.type) {
        case ReceiptObjectType.product:
          value = (obj as ReceiptProduct).price.toString();
          for (ReceiptProduct product in receipt.products) {
            values.add(product.price.toString());
          }
          break;

        case ReceiptObjectType.date:
          value = (obj as ReceiptDate).date;
          for (ReceiptDate date in receipt.dates) {
            values.add(date.date);
          }
          break;

        case ReceiptObjectType.info:
          value = (obj as ReceiptInfo).info;
          for (ReceiptInfo info in receipt.info) {
            values.add(info.info);
          }
          break;
      }

      print('values: $values');
      dataFields.add(
        DataField(
          text: text,
          value: value,
          values: values,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    receipt = widget.initialReceipt;
    initDataFields();
  }

  @override
  void dispose() {
    for (DataField field in dataFields) {
      field.dispose();
    }
    super.dispose();
  }

  get topBarHeight => 200.0;

  get dataFieldsList {
    return ListView.builder(
      itemCount: dataFields.length,
      itemBuilder: (context, index) {
        final dataField = dataFields[index];
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            setState(() {
              dataFields.removeAt(index);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${dataField.getText()} removed'),
                backgroundColor: const Color.fromARGB(73, 0, 0, 0),
                dismissDirection: direction,
              ),
            );
          },
          background: Container(
            decoration: const BoxDecoration(
              gradient: redTransparentGradient,
            ),
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Icon(Icons.highlight_remove_outlined),
            ),
          ),
          child: dataField.widget(index % 2 == 0),
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
