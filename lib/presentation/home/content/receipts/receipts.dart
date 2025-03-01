import 'package:flutter/material.dart';
import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/presentation/home/content/receipts/receipt_entity.dart';

class ReceiptsList extends StatelessWidget {
  final List<ReceiptDocumentData> documentData;
  final Function(int) onItemSelected;
  final Function(int) onItemDeleted;

  const ReceiptsList({
    super.key,
    required this.documentData,
    required this.onItemSelected,
    required this.onItemDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documentData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: ReceiptEntity(
            data: documentData[index],
            onPressed: () {
              onItemSelected(index);
            },
            onRemoved: () {
              onItemDeleted(index);
            },
          ),
        );
      },
    );
  }
}
