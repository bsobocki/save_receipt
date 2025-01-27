import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_button.dart';
import 'package:save_receipt/core/settings/receipt_data_page.dart';

class ReceiptPageTopBar extends StatelessWidget {
  final Function() onSaveReceipt;
  final Function() onDeleteReceipt;
  final VoidCallback onImageIconPress;
  final String? receiptImgPath;
  final String? barcodeImgPaht;
  final ValueNotifier<bool> dataChanged;

  final ThemeController themeController = Get.find();

  ReceiptPageTopBar({
    super.key,
    required this.onImageIconPress,
    this.receiptImgPath,
    this.barcodeImgPaht,
    required this.onSaveReceipt,
    required this.onDeleteReceipt,
    required this.dataChanged,
  });

  get expandedPlaceholder => Expanded(child: Container());

  Widget receiptIcon(String? path, IconData iconData) {
    Widget? icon;
    DecorationImage? image;

    if (path != null) {
      image = DecorationImage(
        image: FileImage(File(path)),
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
      );
    } else {
      icon = Center(child: Icon(iconData));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(15),
          image: image,
        ),
        child: icon,
      ),
    );
  }

  IconData getIconByOption(String text) {
    switch (text) {
      case 'save receipt':
        return Icons.save;
      case 'edit item':
        return Icons.edit;
      case 'remove item':
        return Icons.delete_rounded;
      case 'delete receipt':
        return Icons.playlist_remove_rounded;
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
        color: themeController.theme.mainColor,
        onSelected: (String value) {
          print("chosen: $value");

          switch (value) {
            case 'save receipt':
              onSaveReceipt();
              break;
            case 'delete receipt':
              onDeleteReceipt();
              break;
          }
        },
        itemBuilder: (context) => [
          'save receipt',
          'delete receipt',
          'edit item',
          'remove item'
        ].map((text) => getPopupMenuItem(text)).toList(),
        child: const Icon(Icons.menu),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: ReceiptEditorSettings.topBarNavigationBarHeight,
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: ValueListenableBuilder(
                  valueListenable: dataChanged,
                  builder: (context, value, child) => Badge(
                    isLabelVisible: value,
                    backgroundColor: themeController.theme.extraLightMainColor,
                    child: const Icon(Icons.chevron_left_outlined),
                  ),
                ),
              ),
              expandedPlaceholder,
              popupMenu,
            ],
          ),
        ),
        const SizedBox(height: ReceiptEditorSettings.topBarSpaceHeight),
        SizedBox(
          height: ReceiptEditorSettings.topBarMainContentHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              expandedPlaceholder,
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => Column(
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 2 / 3,
                        child: GestureDetector(
                          onTap: onImageIconPress,
                          child: receiptIcon(receiptImgPath, Icons.image),
                        ),
                      ),
                      SizedBox(
                        height: constraints.maxHeight / 3,
                        child: GestureDetector(
                          onTap: () {},
                          child: receiptIcon(barcodeImgPaht, Icons.qr_code),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpandableButton(
                          buttonColor: themeController.theme.mainColor,
                          iconData: Icons.qr_code,
                          onPressed: () {},
                          label: 'Add barcode',
                          wrapText: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpandableButton(
                          buttonColor: themeController.theme.mainColor,
                          iconData: Icons.add,
                          onPressed: () {},
                          label: 'Add Item',
                          wrapText: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
