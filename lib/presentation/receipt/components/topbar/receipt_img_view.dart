import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:save_receipt/core/settings/receipt_data_page.dart';
import 'package:save_receipt/services/document/scan/google_barcode_scan.dart';

class ReceiptImageView extends StatelessWidget {
  final bool isFormatting;
  final VoidCallback onImageIconPress;
  final Uint8List? documentImgBytes;
  final ReceiptBarcodeData? barcodeData;
  final Uint8List? barcodeImgBytes;
  final String? receiptImgPath;
  final Color mainColor;

  const ReceiptImageView({
    super.key,
    required this.isFormatting,
    required this.onImageIconPress,
    this.documentImgBytes,
    this.barcodeData,
    this.barcodeImgBytes,
    this.receiptImgPath,
    required this.mainColor,
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ReceiptEditorSettings.topBarMainContentHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
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
          const Spacer(),
        ],
      ),
    );
  }
}
