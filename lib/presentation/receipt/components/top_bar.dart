import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:save_receipt/core/settings/receipt_data_page.dart';
import 'package:save_receipt/core/themes/styles/color.dart';
import 'package:save_receipt/services/document/scan/google_barcode_scan.dart';

enum MenuOption { save, delete, selectMode, documentFormat }

String getMenuLabel(MenuOption option, {bool selectMode = false}) =>
    switch (option) {
      MenuOption.save => 'save receipt',
      MenuOption.delete => 'delete receipt',
      MenuOption.documentFormat => 'documentFormat',
      MenuOption.selectMode => selectMode ? 'cancel selection' : 'select items'
    };

class ReceiptPageTopBar extends StatelessWidget {
  final Function() onSaveReceiptOptionPress;
  final Function() onDeleteReceiptOptionPress;
  final Function() onSelectModeToggled;
  final VoidCallback onImageIconPress;
  final String? receiptImgPath;
  final ValueNotifier<bool> dataChanged;
  final Future<bool> Function() onReturnAfterChanges;
  final bool selectMode;
  final ReceiptBarcodeData? barcodeData;
  final VoidCallback onDocumentFormattingOptionPress;
  final bool documentFormat;
  final Uint8List? documentImgBytes;
  final Uint8List? barcodeImgBytes;
  final Color mainColor;
  final bool isFormatting;

  const ReceiptPageTopBar({
    super.key,
    required this.onImageIconPress,
    this.receiptImgPath,
    required this.onSaveReceiptOptionPress,
    required this.onDeleteReceiptOptionPress,
    required this.dataChanged,
    required this.onReturnAfterChanges,
    required this.onSelectModeToggled,
    required this.selectMode,
    this.barcodeData,
    required this.onDocumentFormattingOptionPress,
    required this.documentFormat,
    this.documentImgBytes,
    this.barcodeImgBytes,
    required this.mainColor,
    required this.isFormatting,
  });

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
              color: mainColor,
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
                    style: TextStyle(color: mainColor),
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

    if (isFormatting) {
      child =
          LoadingAnimationWidget.hexagonDots(color: Colors.white, size: 30.0);
    } else if (documentImgBytes != null) {
      child = Image.memory(
        documentImgBytes!,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      );
    } else if (receiptImgPath != null) {
      child = Image.file(
        File(receiptImgPath!),
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      );
    }
    child ??= const Center(child: Icon(Icons.receipt_long_rounded));

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

  Widget get barcodeField {
    Widget? child;
    if (isFormatting) {
      child = Center(
        child: LoadingAnimationWidget.progressiveDots(
            color: Colors.white, size: 20.0),
      );
    } else if (barcodeImgBytes != null) {
      try {
        child = Image.memory(
          barcodeImgBytes!,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        );
      } catch (e) {
        print("::::::::::::::: Error displaying image from bytes: $e");
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
              getMenuLabel(option, selectMode: selectMode),
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
            case MenuOption.selectMode:
              onSelectModeToggled();
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

  Widget get returnButton => ValueListenableBuilder(
      valueListenable: dataChanged,
      builder: (context, dataChangedValue, child) {
        return IconButton(
          onPressed: () async {
            bool closePage = true;
            if (dataChangedValue) {
              closePage = await onReturnAfterChanges();
            }
            if (closePage && context.mounted) Navigator.pop(context);
          },
          icon: Badge(
            isLabelVisible: dataChangedValue,
            backgroundColor: mainColor.moved(80),
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
                      onTap: onImageIconPress,
                      child: receiptField,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => showBarcodeDialog(
                        title: "Barcode",
                        data: barcodeData?.value,
                        barcode: barcodeData?.format,
                        context: context,
                      ),
                      child: barcodeField,
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
