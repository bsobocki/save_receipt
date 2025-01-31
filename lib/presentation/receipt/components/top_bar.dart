import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_button.dart';
import 'package:save_receipt/core/settings/receipt_data_page.dart';

class ReceiptPageTopBar extends StatelessWidget {
  final Function() onSaveReceiptOptionPress;
  final Function() onDeleteReceiptOptionPress;
  final VoidCallback onImageIconPress;
  final String? receiptImgPath;
  final String? barcodeImgPaht;
  final ValueNotifier<bool> dataChanged;
  final Future<void> Function() onReturnAfterChanges;

  final ThemeController themeController = Get.find();

  ReceiptPageTopBar({
    super.key,
    required this.onImageIconPress,
    this.receiptImgPath,
    this.barcodeImgPaht,
    required this.onSaveReceiptOptionPress,
    required this.onDeleteReceiptOptionPress,
    required this.dataChanged,
    required this.onReturnAfterChanges,
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
          switch (value) {
            case 'save receipt':
              onSaveReceiptOptionPress();
              break;
            case 'delete receipt':
              onDeleteReceiptOptionPress();
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

  Widget get returnButton => ValueListenableBuilder(
      valueListenable: dataChanged,
      builder: (context, dataChangedValue, child) {
        return IconButton(
          onPressed: () async {
            if (dataChangedValue) await onReturnAfterChanges();
            if (context.mounted) Navigator.pop(context);
          },
          icon: Badge(
            isLabelVisible: dataChangedValue,
            backgroundColor: themeController.theme.extraLightMainColor,
            child: const Icon(Icons.chevron_left_outlined),
          ),
        );
      });

  Widget get navigationTopBar => SizedBox(
        height: ReceiptEditorSettings.topBarNavigationBarHeight,
        child: Row(
          children: [
            returnButton,
            expandedPlaceholder,
            popupMenu,
          ],
        ),
      );

  Widget get emptyVerticalSpace =>
      const SizedBox(height: ReceiptEditorSettings.topBarSpaceHeight);

  List<Widget> get additionalOptions => [
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
      ];

  Widget get panel => SizedBox(
        height: ReceiptEditorSettings.topBarMainContentHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            expandedPlaceholder,
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: onImageIconPress,
                      child: receiptIcon(receiptImgPath, Icons.image),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {},
                      child: receiptIcon(barcodeImgPaht, Icons.qr_code),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: additionalOptions,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        navigationTopBar,
        emptyVerticalSpace,
        panel,
      ],
    );
  }
}
