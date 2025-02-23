import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:barcode_widget/barcode_widget.dart' as barcode_widget;
import 'package:image/image.dart' as img;

class ReceiptBarcodeData {
  final String? value;
  final Uint8List? imgBytes;
  final barcode_widget.Barcode format;

  const ReceiptBarcodeData(this.value, this.imgBytes, this.format);
}

class GoogleBarcodeScanner {
  final String path;
  BarcodeFormat? format;
  Uint8List? imgBytes;
  String? value;

  GoogleBarcodeScanner(this.path);

  barcode_widget.Barcode get getBarcodeFormat {
    if (format == null) return barcode_widget.Barcode.code128();
    switch (format) {
      case BarcodeFormat.code128:
        return barcode_widget.Barcode.code128();
      case BarcodeFormat.qrCode:
        return barcode_widget.Barcode.qrCode();
      case BarcodeFormat.ean13:
        return barcode_widget.Barcode.ean13();
      default:
        return barcode_widget.Barcode.code128(); // Default type
    }
  }

  Future<void> scanImage() async {
    final inputImage = InputImage.fromFilePath(path);
    final List<BarcodeFormat> formats = [BarcodeFormat.all];
    final BarcodeScanner scanner = BarcodeScanner(formats: formats);
    final List<Barcode> barcodes = await scanner.processImage(inputImage);

    Barcode? barcode = barcodes.firstOrNull;
    if (barcode != null) {
      format = barcode.format;
      value = barcode.rawValue;
      imgBytes = barcodeImgBytes(barcode.boundingBox);
    }
  }

  Uint8List? barcodeImgBytes(Rect boundingBox) {
    try {
      img.Image? receiptImg = img.decodeImage(File(path).readAsBytesSync());
      if (receiptImg == null) {
        print("=-=-=-=-=- Failed to decode image from path: $path");
        return null;
      }

      int x = boundingBox.left.toInt();
      int y = boundingBox.top.toInt();
      int width = boundingBox.width.toInt();
      int height = boundingBox.height.toInt();

      if (x < 0 ||
          y < 0 ||
          x + width > receiptImg.width ||
          y + height > receiptImg.height) {
        print("=-=-=-=-= Bounding box is out of image bounds");
        return null;
      }

      img.Image barcodeImg = img.copyCrop(
        receiptImg,
        x: x,
        y: y,
        width: width,
        height: height,
      );

      print("========== format type= ${barcodeImg.formatType} -- format = ${barcodeImg.format}");

      return Uint8List.fromList(img.encodeJpg(barcodeImg));
    } catch (e) {
      print("Error processing barcode image: $e");
      return null;
    }
  }

  ReceiptBarcodeData get data =>
      ReceiptBarcodeData(value, imgBytes, getBarcodeFormat);

  void printBarcodeData(Barcode barcode) {
    print('barcode from $path  :');
    print('format: ${barcode.format}');
    print('type: ${barcode.type}');
    print('raw value: ${barcode.rawValue}');
    print('value: ${barcode.value}');
    print('display value: ${barcode.displayValue}');
    print('bounding box: ${barcode.boundingBox}');
  }
}
