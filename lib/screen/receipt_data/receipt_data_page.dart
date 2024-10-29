import 'dart:io';

import 'package:flutter/material.dart';
import 'package:save_receipt/color/background/gradient.dart';
import 'package:save_receipt/components/receipt_image.dart';
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

      switch (obj.type) {
        case ReceiptObjectType.product:
          value = (obj as Product).price.toString();
          break;

        case ReceiptObjectType.date:
          value = (obj as Date).date;
          break;

        case ReceiptObjectType.info:
          value = (obj as TwoPartInfo).info;
          break;
      }

      dataFields.add(
        DataField(
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
        return dataFields[index].widget(index % 2 == 0);
      },
    );
  }

  get background {
    return Column(
      children: [
        Container(
          height: 300,
          decoration: const BoxDecoration(
            gradient: mainGradient,
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }

  get receiptIcon {
    if (receipt.imgPath != null) {
      return Image.file(File(receipt.imgPath!), fit: BoxFit.cover);
    }
    return Image.asset("assets/no_image.jpg");
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

  get topBar => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.chevron_left_outlined),
                ),
                Expanded(
                  child: Container(),
                ),
                IconButton(
                  onPressed: () => print('pressed save'),
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: IconButton(
              onPressed: () {
                if (receipt.imgPath != null) {
                  setState(() {
                    showFullScreenReceiptImage = true;
                  });
                } else {
                  print("no - image");
                }
              },
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: receiptIcon,
              ),
            ),
          ),
        ],
      );

  get widgets {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 32.0,
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Column(
          children: [
            topBar,
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
      widgets,
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
