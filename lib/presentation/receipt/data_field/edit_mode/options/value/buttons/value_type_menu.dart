import 'package:flutter/material.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_button.dart';
import 'package:save_receipt/domain/entities/receipt.dart';

class DataFieldValueTypeMenu extends StatefulWidget {
  const DataFieldValueTypeMenu({
    super.key,
    required this.onSelected,
    required this.color,
    required this.type,
    required this.buttonColor,
  });

  final Function(ReceiptModelObjectType) onSelected;
  final Color color;
  final ReceiptModelObjectType type;
  final Color buttonColor;

  @override
  State<DataFieldValueTypeMenu> createState() => _DataFieldValueTypeMenuState();
}

class _DataFieldValueTypeMenuState extends State<DataFieldValueTypeMenu> {
  late ReceiptModelObjectType type;

  @override
  void initState() {
    super.initState();
    type = widget.type;
  }

  PopupMenuItem<ReceiptModelObjectType> getPopupMenuItem(
      String text, ReceiptModelObjectType type) {
    return PopupMenuItem<ReceiptModelObjectType>(
        value: type,
        child: Row(
          children: [
            Icon(getTypeIcon(type), color: Colors.white),
            const SizedBox(width: 8),
            Text(text),
          ],
        ));
  }

  IconData getTypeIcon(ReceiptModelObjectType type) {
    switch (type) {
      case ReceiptModelObjectType.object:
        return Icons.question_mark_sharp;
      case ReceiptModelObjectType.product:
        return Icons.price_change;
      case ReceiptModelObjectType.info:
        return Icons.info;
      case ReceiptModelObjectType.date:
        return Icons.calendar_month;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey buttonKey = GlobalKey();

    return PopupMenuButton<ReceiptModelObjectType>(
      key: buttonKey,
      onSelected: (ReceiptModelObjectType value) => setState(() {
        widget.onSelected(value);
        type = value;
      }),
      itemBuilder: (context) => [
        getPopupMenuItem('price', ReceiptModelObjectType.product),
        getPopupMenuItem('info', ReceiptModelObjectType.info),
        getPopupMenuItem('date', ReceiptModelObjectType.date),
      ],
      color: widget.color,
      // custom button
      // need to open menu using key
      child: ExpandableButton(
        label: "Select Type",
        onPressed: () {
          // This will trigger the PopupMenuButton
          dynamic state = buttonKey.currentState;
          state?.showButtonMenu();
        },
        buttonColor: widget.buttonColor,
        iconData: getTypeIcon(type),
        iconColor: widget.color,
        textColor: Colors.white,
      ),
    );
  }
}
