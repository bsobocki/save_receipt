import 'package:flutter/material.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';

class DataFieldValueTypeMenu extends StatefulWidget {
  const DataFieldValueTypeMenu({
    required this.onSelected,
    required this.color,
    required this.type,
    super.key,
  });

  final Function(ReceiptObjectType) onSelected;
  final Color color;
  final ReceiptObjectType type;

  @override
  State<DataFieldValueTypeMenu> createState() => _DataFieldValueTypeMenuState();
}

class _DataFieldValueTypeMenuState extends State<DataFieldValueTypeMenu> {
  late ReceiptObjectType type;

  @override
  void initState() {
    super.initState();
    type = widget.type;
  }

  PopupMenuItem<ReceiptObjectType> getPopupMenuItem(
      String text, ReceiptObjectType type) {
    return PopupMenuItem<ReceiptObjectType>(
        value: type,
        child: Row(
          children: [
            Icon(getTypeIcon(type), color: Colors.white),
            const SizedBox(width: 8),
            Text(text),
          ],
        ));
  }

  IconData getTypeIcon(ReceiptObjectType type) {
    switch (type) {
      case ReceiptObjectType.object:
        return Icons.question_mark_sharp;
      case ReceiptObjectType.product:
        return Icons.price_change;
      case ReceiptObjectType.info:
        return Icons.info;
      case ReceiptObjectType.date:
        return Icons.calendar_month;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ReceiptObjectType>(
      onSelected: (ReceiptObjectType value) => setState(() {
        widget.onSelected(value);
        type = value;
      }),
      itemBuilder: (context) => [
        getPopupMenuItem('price', ReceiptObjectType.product),
        getPopupMenuItem('info', ReceiptObjectType.info),
        getPopupMenuItem('date', ReceiptObjectType.date),
      ],
      color: widget.color,
      child: CircleAvatar(
        backgroundColor: widget.color,
        child: Icon(
          getTypeIcon(type),
          color: Colors.white,
        ),
      ),
    );
  }
}
