
import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart';
import 'package:save_receipt/services/images/image_operations.dart';

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

  return textLines;
}