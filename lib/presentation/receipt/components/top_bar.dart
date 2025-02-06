import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_button.dart';
import 'package:save_receipt/core/settings/receipt_data_page.dart';

enum MenuOption { save, delete, removeItem, selectMode }

String getMenuLabel(MenuOption option, {bool selectMode = false}) =>
    switch (option) {
      MenuOption.save => 'save receipt',
      MenuOption.delete => 'delete receipt',
      MenuOption.removeItem => 'remove item',
      MenuOption.selectMode => selectMode ? 'cancel selection' : 'select items'
    };

class ReceiptPageTopBar extends StatelessWidget {
  final Function() onSaveReceiptOptionPress;
  final Function() onDeleteReceiptOptionPress;
  final Function() onSelectModeToggled;
  final VoidCallback onImageIconPress;
  final String? receiptImgPath;
  final String? barcodeImgPaht;
  final ValueNotifier<bool> dataChanged;
  final Future<void> Function() onReturnAfterChanges;
  final bool selectMode;

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
    required this.onSelectModeToggled,
    required this.selectMode,
  });

  Widget expandedPlaceholder({int flex = 1}) =>
      Expanded(flex: flex, child: Container());

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

  IconData getIconByOption(MenuOption text) {
    switch (text) {
      case MenuOption.save:
        return Icons.save;
      case MenuOption.delete:
        return Icons.delete_rounded;
      case MenuOption.removeItem:
        return Icons.playlist_remove_rounded;
      default:
        return Icons.keyboard_option_key;
    }
  }

  PopupMenuItem<MenuOption> getPopupMenuItem(MenuOption option) {
    return PopupMenuItem<MenuOption>(
        value: option,
        child: Row(
          children: [
            Icon(getIconByOption(option), color: Colors.white),
            const SizedBox(width: 8),
            Text(getMenuLabel(option, selectMode: selectMode)),
          ],
        ));
  }

  get popupMenu => PopupMenuButton<MenuOption>(
        color: themeController.theme.mainColor,
        onSelected: (MenuOption value) {
          switch (value) {
            case MenuOption.save:
              onSaveReceiptOptionPress();
              break;
            case MenuOption.delete:
              onDeleteReceiptOptionPress();
              break;
            case MenuOption.selectMode:
              onSelectModeToggled();
              break;
            default:
              break;
          }
        },
        itemBuilder: (context) => MenuOption.values
            .map((option) => getPopupMenuItem(option))
            .toList(),
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
            expandedPlaceholder(),
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
            expandedPlaceholder(flex: selectMode ? 1 : 2),
            Expanded(
              flex: 2,
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
            selectMode
                ? Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: additionalOptions,
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: Container(),
                  )
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
