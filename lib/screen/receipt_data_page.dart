import 'package:flutter/material.dart';
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
      if (obj.type == ReceiptObjectType.product) {
        Product product = obj as Product;
        dataFields.add(
          DataField(
            text: product.text,
            value: product.price.toString(),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    receipt = widget.initialReceipt;
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
        return TextField(
          autocorrect: false,
        );
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
              onPressed: () => print('saved'), icon: const Icon(Icons.save))
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Container();
          },
        ),
      ),
    );
  }
}

class DataField {
  TextEditingController textController = TextEditingController();
  TextEditingController? valueController;
  late TextField textField;
  late TextField valueField;

  DataField({String? text, String? value}) {
    if (text != null) {
      textController.text = text;
    }
    if (value != null) {
      valueController = TextEditingController();
      valueController!.text = value;
    }
    textField = TextField(
      autocorrect: false,
      controller: textController,
    );
    valueField = TextField(
      autocorrect: false,
      controller: valueController,
    );
  }

  void dispose() {
    textController.dispose();
    valueController?.dispose();
  }

  String getText() => textController.text;
  String getValue() => valueController?.text ?? '';
}
