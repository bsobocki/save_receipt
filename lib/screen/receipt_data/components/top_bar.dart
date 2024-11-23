import 'dart:io';

import 'package:flutter/material.dart';
import 'package:save_receipt/screen/receipt_data/components/expandable_button.dart';

class ReceiptPageTopBar extends StatelessWidget {
  const ReceiptPageTopBar(
      {super.key, this.receiptImgPath, required this.onImageIconPress});
  final VoidCallback onImageIconPress;
  final String? receiptImgPath;

  get receiptIcon {
    if (receiptImgPath != null) {
      return Image.file(File(receiptImgPath!), fit: BoxFit.cover);
    }
    return Image.asset("assets/no_image.jpg");
  }

  IconData getIconByOption(String text) {
    switch (text) {
      case 'save receipt':
        return Icons.save;
      case 'edit item':
        return Icons.edit;
      case 'remove item':
        return Icons.delete_rounded;
      default:
        return Icons.keyboard_option_key;
    }
  }

  PopupMenuItem<String> getPopupMenuItem(String text) {
    return PopupMenuItem<String>(
        value: text,
        child: Row(
          children: [
            Icon(getIconByOption(text), color: Colors.white),
            const SizedBox(width: 8),
            Text(text),
          ],
        ));
  }

  get popupMenu => PopupMenuButton<String>(
        color: Colors.black,
        onSelected: (String value) {
          print("chosen: $value");
        },
        itemBuilder: (context) => ['save receipt', 'edit item', 'remove item']
            .map((text) => getPopupMenuItem(text))
            .toList(),
        child: const Icon(Icons.menu),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
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
              popupMenu,
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 160,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onImageIconPress,
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: receiptIcon,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpandableButton(
                        buttonColor: Colors.red,
                        iconData: Icons.qr_code,
                        onPressed: () {},
                        label: 'Add barcode'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpandableButton(
                        buttonColor: Colors.cyan,
                        iconData: Icons.add,
                        onPressed: () {},
                        label: 'Add Item'),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
