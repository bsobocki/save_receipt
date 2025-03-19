import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/settings/receipt_data_page.dart';
import 'package:save_receipt/core/themes/styles/color.dart';

enum MenuOption { save, delete, selectionMode, documentFormat }

class NavigationTopbar extends StatelessWidget {
  final bool selectionMode;
  final bool documentFormat;
  final Color mainColor;
  final RxBool dataChanged;
  final Future<bool> Function() onReturnAfterChanges;
  final Function() onSaveReceiptOptionPress;
  final Function() onDeleteReceiptOptionPress;
  final Function() onSelectionModeToggled;
  final Function() onDocumentFormattingOptionPress;

  const NavigationTopbar({
    super.key,
    required this.selectionMode,
    required this.documentFormat,
    required this.mainColor,
    required this.dataChanged,
    required this.onReturnAfterChanges,
    required this.onSaveReceiptOptionPress,
    required this.onDeleteReceiptOptionPress,
    required this.onSelectionModeToggled,
    required this.onDocumentFormattingOptionPress,
  });

  String getMenuLabel(MenuOption option, {bool selectionMode = false}) =>
      switch (option) {
        MenuOption.save => 'save receipt',
        MenuOption.delete => 'delete receipt',
        MenuOption.documentFormat => 'documentFormat',
        MenuOption.selectionMode =>
          selectionMode ? 'cancel selection' : 'select items'
      };

  IconData getIconByOption(MenuOption text) {
    switch (text) {
      case MenuOption.save:
        return Icons.save;
      case MenuOption.delete:
        return Icons.delete_rounded;
      case MenuOption.selectionMode:
        return Icons.select_all;
      case MenuOption.documentFormat:
        return documentFormat
            ? Icons.check_box_outlined
            : Icons.check_box_outline_blank_outlined;
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
            Text(
              getMenuLabel(option, selectionMode: selectionMode),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ));
  }

  get popupMenu => PopupMenuButton<MenuOption>(
        color: mainColor,
        onSelected: (MenuOption value) {
          switch (value) {
            case MenuOption.save:
              onSaveReceiptOptionPress();
              break;
            case MenuOption.delete:
              onDeleteReceiptOptionPress();
              break;
            case MenuOption.selectionMode:
              onSelectionModeToggled();
              break;
            case MenuOption.documentFormat:
              onDocumentFormattingOptionPress();
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

  Widget get returnButton => Obx(() {
        return IconButton(
          onPressed: () async {
            bool closePage = true;
            if (dataChanged.value) {
              closePage = await onReturnAfterChanges();
            }
            if (closePage) Get.back();
          },
          icon: Badge(
            isLabelVisible: dataChanged.value,
            backgroundColor: mainColor.moved(80),
            child: const Icon(Icons.chevron_left_outlined),
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ReceiptEditorSettings.topBarNavigationBarHeight,
      child: Row(
        children: [
          returnButton,
          const Spacer(),
          popupMenu,
        ],
      ),
    );
  }
}
