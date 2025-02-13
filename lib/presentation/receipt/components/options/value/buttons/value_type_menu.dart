import 'package:flutter/material.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_button.dart';

class DataFieldValueTypeMenu extends StatefulWidget {
  const DataFieldValueTypeMenu({
    super.key,
    required this.onTypeChanged,
    required this.color,
    required this.type,
    required this.buttonColor,
  });

  final Function(ReceiptObjectModelType)? onTypeChanged;
  final Color color;
  final ReceiptObjectModelType type;
  final Color buttonColor;

  @override
  State<DataFieldValueTypeMenu> createState() => _DataFieldValueTypeMenuState();
}

class _DataFieldValueTypeMenuState extends State<DataFieldValueTypeMenu> {
  late ReceiptObjectModelType type;

  @override
  void initState() {
    super.initState();
    type = widget.type;
  }

  PopupMenuItem<ReceiptObjectModelType> getPopupMenuItem(
      String text, ReceiptObjectModelType type) {
    return PopupMenuItem<ReceiptObjectModelType>(
        value: type,
        child: Row(
          children: [
            Icon(getTypeIcon(type), color: Colors.white),
            const SizedBox(width: 8),
            Text(text),
          ],
        ));
  }

  IconData getTypeIcon(ReceiptObjectModelType type) {
    switch (type) {
      case ReceiptObjectModelType.object:
        return Icons.question_mark_sharp;
      case ReceiptObjectModelType.infoDouble:
        return Icons.price_change;
      case ReceiptObjectModelType.infoText:
        return Icons.text_fields_sharp;
      case ReceiptObjectModelType.infoTime:
        return Icons.calendar_month;
      case ReceiptObjectModelType.infoNumeric:
        return Icons.looks_one_outlined;
      default:
        return Icons.question_mark_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey buttonKey = GlobalKey();

    return PopupMenuButton<ReceiptObjectModelType>(
      key: buttonKey,
      onSelected: (ReceiptObjectModelType newType) => setState(() {
        type = newType;
        widget.onTypeChanged?.call(newType);
      }),
      itemBuilder: (context) => [
        getPopupMenuItem('text', ReceiptObjectModelType.infoText),
        getPopupMenuItem('time', ReceiptObjectModelType.infoTime),
        getPopupMenuItem('price', ReceiptObjectModelType.infoDouble),
        getPopupMenuItem('numeric', ReceiptObjectModelType.infoNumeric),
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
