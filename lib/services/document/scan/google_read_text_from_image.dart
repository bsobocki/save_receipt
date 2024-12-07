
import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart';
import 'package:save_receipt/services/document/image/image_operations.dart';

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

  // int i = 0;
  // print("-=-=-=-=-=-=-=");
  // recognizedText.blocks
  //     .sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));
  // for (var block in recognizedText.blocks) {
  //   print('$i:');
  //   print('lines:');
  //   for (var line in block.lines) {
  //     print('text: ${line.text}');
  //     print('line angle: ${line.angle}');
  //     print('line box: ${line.boundingBox}');
  //     print('line height: ${line.boundingBox.height}');
  //     print('line center: ${line.boundingBox.center}');
  //     print('line box bottom left: ${line.boundingBox.bottomLeft}');
  //     print('line box bottom right: ${line.boundingBox.bottomRight}');
  //   }
  //   i++;
  //   print('===');
  // }
  // TextLine nameElem = recognizedText.blocks[14].lines[0];
  // TextLine valueElem = recognizedText.blocks[13].lines[0];
  // VerticalMargin margin = VerticalMargin.calc(nameElem.angle!,
  //     nameElem.boundingBox.center, valueElem.boundingBox.center.dx,
  //     err: nameElem.boundingBox.height);
  // print(
  //     "quickCheck: name rect: ${nameElem.boundingBox}  ||  valueElem: ${valueElem.boundingBox}");
  // print('margin : ${margin}');
  // print(
  //     "is in margin ${valueElem.boundingBox.center.dy}? -> ${margin.inMargin(valueElem.boundingBox.center.dy)}");
  // print("-=-=-=-=-=-=-=");

  return textLines;
}