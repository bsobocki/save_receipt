import 'package:flutter/material.dart';
import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/presentation/home/content/receipts/receipt_entity.dart';

class ReceiptsList extends StatefulWidget {
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
  State<ReceiptsList> createState() => _ReceiptsListState();
}

class _ReceiptsListState extends State<ReceiptsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.documentData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: ReceiptEntity(
            data: widget.documentData[index],
            onPressed: () {
              widget.onItemSelected(index);
            },
            onRemoved: () {
              widget.onItemDeleted(index);
            },
          ),
        );
      },
    );
  }
}
