import 'package:flutter/material.dart';
import 'package:save_receipt/screen/receipt_data/data_field.dart';
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

  Widget getDataFieldsList() {
    return ListView.builder(
      itemCount: dataFields.length,
      itemBuilder: (context, index) {
        return dataFields[index].widget;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: getDataFieldsList(),
      ),
    );
  }
}
