import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/core/settings/receipt_data_page.dart';
import 'package:save_receipt/services/document/scan/google_barcode_scan.dart';

enum MenuOption { save, delete, removeItem, selectMode }

String getMenuLabel(MenuOption option, {bool selectMode = false}) =>
    switch (option) {
      MenuOption.save => 'save receipt',
      MenuOption.delete => 'delete receipt',
      MenuOption.removeItem => 'remove item',
      MenuOption.selectMode => selectMode ? 'cancel selection' : 'select items'
    };

class ReceiptPageTopBar extends StatefulWidget {
  final Function() onSaveReceiptOptionPress;
  final Function() onDeleteReceiptOptionPress;
  final Function() onSelectModeToggled;
  final VoidCallback onImageIconPress;
  final String? receiptImgPath;
  final String? barcodeImgPaht;
  final ValueNotifier<bool> dataChanged;
  final Future<bool> Function() onReturnAfterChanges;
  final bool selectMode;

  const ReceiptPageTopBar({
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

  @override
  State<ReceiptPageTopBar> createState() => _ReceiptPageTopBarState();
}

class _ReceiptPageTopBarState extends State<ReceiptPageTopBar> {
  final ThemeController themeController = Get.find();
  ReceiptBarcodeData? barcodeData;

  Future<void> showAlertDialog({
    required String title,
    required String? data,
    required Barcode barcode,
    required BuildContext context,
  }) async {
    List<Widget> actions = [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("OK"),
      ),
    ];

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: themeController.theme.mainColor,
            ),
          ),
          content: Container(
            constraints: const BoxConstraints(maxHeight: 120),
            child: data != null ?
            BarcodeWidget(
              data: data,
              barcode: barcode,
              drawText: true,
              style: const TextStyle(color: Colors.black),
            )
            : Center(child: Text("Invalid Data", style: TextStyle(color: themeController.theme.mainColor),)),
          ),
          actions: actions,
        );
      },
    );
  }

  Widget expandedPlaceholder({int flex = 1}) =>
      Expanded(flex: flex, child: Container());

  Widget receiptIcon(
      {String? path, Uint8List? bytes, required IconData iconData}) {
    Widget? icon;
    DecorationImage? image;
    ImageProvider? imgProvider;

    if (path != null) {
      imgProvider = FileImage(File(path));
    }

    if (bytes != null) {
      try {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.memory(
                bytes,
                fit: BoxFit.fitHeight,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        );
      } catch (e) {
        print("Error displaying image from bytes: $e");
      }
    }

    if (imgProvider != null) {
      image = DecorationImage(
        image: imgProvider,
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
      case MenuOption.selectMode:
        return Icons.select_all;
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
            Text(getMenuLabel(option, selectMode: widget.selectMode)),
          ],
        ));
  }

  get popupMenu => PopupMenuButton<MenuOption>(
        color: themeController.theme.mainColor,
        onSelected: (MenuOption value) {
          switch (value) {
            case MenuOption.save:
              widget.onSaveReceiptOptionPress();
              break;
            case MenuOption.delete:
              widget.onDeleteReceiptOptionPress();
              break;
            case MenuOption.selectMode:
              widget.onSelectModeToggled();
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
      valueListenable: widget.dataChanged,
      builder: (context, dataChangedValue, child) {
        return IconButton(
          onPressed: () async {
            bool closePage = true;
            if (dataChangedValue) {
              closePage = await widget.onReturnAfterChanges();
            }
            if (closePage && context.mounted) Navigator.pop(context);
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

  Widget panel(BuildContext context) => SizedBox(
        height: ReceiptEditorSettings.topBarMainContentHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            expandedPlaceholder(),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: widget.onImageIconPress,
                      child: receiptIcon(
                        path: widget.receiptImgPath,
                        iconData: Icons.image,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        if (widget.receiptImgPath != null) {
                          if (barcodeData == null) {
                            GoogleBarcodeScanner scanner =
                                GoogleBarcodeScanner(widget.receiptImgPath!);
                            await scanner.scanImage();
                            setState(() => barcodeData = scanner.data);
                          }
                          if (context.mounted) {
                            await showAlertDialog(
                              title: "Barcode",
                              data: barcodeData!.value,
                              barcode: barcodeData!.format,
                              context: context,
                            );
                          }
                        }
                      },
                      child: receiptIcon(
                          bytes: barcodeData?.imgBytes,
                          iconData: Icons.qr_code),
                    ),
                  ),
                ],
              ),
            ),
            expandedPlaceholder(),
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
        panel(context),
      ],
    );
  }
}
