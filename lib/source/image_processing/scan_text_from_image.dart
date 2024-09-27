import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<String> scanTextFromImage(String imageFilePath) async {
  final inputImage = InputImage.fromFilePath(imageFilePath);
  final textRecognizer = TextRecognizer();

  final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);

  // String output = "";
  // for (TextBlock block in recognizedText.blocks) {
  //   for (TextLine line in block.lines) {
  //     output += "${line.text}\n";
  //   }
  // }

  // textRecognizer.close();
  // return output;
  return recognizedText.text.toString();
}
