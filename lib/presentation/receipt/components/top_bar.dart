import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/core/settings/receipt_data_page.dart';
import 'package:save_receipt/services/document/scan/google_barcode_scan.dart';
import 'package:save_receipt/services/images/edit_image.dart';

enum MenuOption { save, delete, selectMode, documentFormat }

String getMenuLabel(MenuOption option, {bool selectMode = false}) =>
    switch (option) {
      MenuOption.save => 'save receipt',
      MenuOption.delete => 'delete receipt',
      MenuOption.documentFormat => 'documentFormat',
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
  final ReceiptBarcodeData? barcodeData;
  final VoidCallback onDocumentFormattingOptionPress;
  final bool documentFormat;

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
    this.barcodeData,
    required this.onDocumentFormattingOptionPress,
    required this.documentFormat,
  });

  @override
  State<ReceiptPageTopBar> createState() => _ReceiptPageTopBarState();
}

class _ReceiptPageTopBarState extends State<ReceiptPageTopBar> {
  final ThemeController themeController = Get.find();

  Future<void> showBarcodeDialog({
    required String title,
    required String? data,
    required Barcode? barcode,
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
            child: data != null
                ? BarcodeWidget(
                    data: data,
                    barcode: barcode ?? Barcode.code128(),
                    drawText: true,
                    style: const TextStyle(color: Colors.black),
                  )
                : Center(
                    child: Text(
                    "No barcode found..",
                    style: TextStyle(color: themeController.theme.mainColor),
                  )),
          ),
          actions: actions,
        );
      },
    );
  }

  Widget expandedPlaceholder({int flex = 1}) =>
      Expanded(flex: flex, child: Container());

  Widget get receiptField {
    Widget? child;
    DecorationImage? imageBackground;

    if (widget.receiptImgPath != null) {
      bool fromBytes = false;
      if (widget.documentFormat) {
        var bytes =
            adjustDocumentBytes(File(widget.receiptImgPath!).readAsBytesSync());
        if (bytes != null) {
          child = Image.memory(
            bytes,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          );
          fromBytes = true;
        }
      }
      if (!fromBytes) {
        child = Image.file(
          File(widget.receiptImgPath!),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        );
      }
    } else {
      child = const Center(child: Icon(Icons.receipt_long_rounded));
    }

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(15),
            image: imageBackground,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget barcodeField({Uint8List? bytes}) {
    Widget? child;
    if (widget.documentFormat) {
      bytes = adjustDocumentBytes(bytes);
    }
    if (bytes != null) {
      try {
        child = Image.memory(
          bytes,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        );
      } catch (e) {
        print("Error displaying image from bytes: $e");
        child = null;
      }
    }

    child ??= Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: //Icon(Icons.qr_code)
          SizedBox(
        width: 30,
        child: BarcodeWidget(
          data: '0050',
          barcode: Barcode.itf(),
          drawText: false,
          color: Colors.white,
        ),
      ),
    ));

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(9),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: child,
          ),
        ),
      ),
    );
  }

  IconData getIconByOption(MenuOption text) {
    switch (text) {
      case MenuOption.save:
        return Icons.save;
      case MenuOption.delete:
        return Icons.delete_rounded;
      case MenuOption.selectMode:
        return Icons.select_all;
      case MenuOption.documentFormat:
        return widget.documentFormat
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
            case MenuOption.documentFormat:
              widget.onDocumentFormattingOptionPress();
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
                    flex: 3,
                    child: GestureDetector(
                      onTap: widget.onImageIconPress,
                      child: receiptField,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => showBarcodeDialog(
                        title: "Barcode",
                        data: widget.barcodeData?.value,
                        barcode: widget.barcodeData?.format,
                        context: context,
                      ),
                      child: barcodeField(bytes: widget.barcodeData?.imgBytes),
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
