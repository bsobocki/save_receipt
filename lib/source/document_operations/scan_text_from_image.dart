import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart';
import 'package:save_receipt/source/document_operations/image/image_operations.dart';
import 'package:save_receipt/source/document_operations/math/coordinates.dart';

Future<List<TextLine>> processImage(String imagePath) async {
  final image = decodeImage(File(imagePath).readAsBytesSync());

  if (image!.width < 32 || image.height < 32) {
    final resizedImage = resizeImageWithPadding(image);
    String tmpImgPath = await saveTemporaryImage(resizedImage);
    List<TextLine> output = await scanTextFromImage(tmpImgPath);
    deleteTemporaryImage(tmpImgPath);
    return output;
  }

  return await scanTextFromImage(imagePath);
}

Future<List<TextLine>> scanTextFromImage(String imageFilePath) async {
  final inputImage = InputImage.fromFilePath(imageFilePath);
  final textRecognizer = TextRecognizer();

  final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);

  List<TextLine> textLines = [];
  for (var block in recognizedText.blocks) {
    textLines += block.lines;
  }

  int i = 0;
  print("-=-=-=-=-=-=-=");
  recognizedText.blocks
      .sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));
  for (var block in recognizedText.blocks) {
    print('$i:');
    print('top: ${block.boundingBox.top}');
    print('lines:');
    for (var line in block.lines) {
      print('text: ${line.text}');
      print('line angle: ${line.angle}');
      print('line box: ${line.boundingBox}');
      print('line center: ${line.boundingBox.center}');
      print('line box bottom left: ${line.boundingBox.bottomLeft}');
      print('line box bottom right: ${line.boundingBox.bottomRight}');
    }
    i++;
    print('===');
  }
  TextLine gotowkaElem = recognizedText.blocks[14].lines[0];
  print(
      'Gotowka from angle: ${VerticalMargin.calc(gotowkaElem.angle!, gotowkaElem.boundingBox.center, 341.0)}');
  print("-=-=-=-=-=-=-=");

  return textLines;
}

Future<String> scanRecipe() async {
  final documentScanner = DocumentScanner(
    options: DocumentScannerOptions(
        documentFormat: DocumentFormat.jpeg,
        isGalleryImport: true,
        mode: ScannerMode.full,
        pageLimit: 1), // Set to more if you want to scan multiple documents
  );

  try {
    final DocumentScanningResult document =
        await documentScanner.scanDocument();
    final List<String> images = document.images;

    if (images.isNotEmpty) {
      return images[0];
    }
  } catch (err) {
    return 'Error scanning document: $err';
  }

  return '';
}
