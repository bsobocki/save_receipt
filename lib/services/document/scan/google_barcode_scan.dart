import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:barcode_widget/barcode_widget.dart' as barcode_widget;

class GoogleBarcodeScanner {
  late final Barcode barcode;
  late final BarcodeFormat format;
  final String path;
  String value = '';

  GoogleBarcodeScanner(this.path);

  barcode_widget.Barcode getBarcodeFormat() {
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

    for (Barcode barcode in barcodes) {
      format = barcode.format;

      print('barcode from $path  :');
      print('format: $format');
      print('type: ${barcode.type}');
      print('raw value: ${barcode.rawValue}');
      print('value: ${barcode.value}');
      print('display value: ${barcode.displayValue}');
      print('bounding box: ${barcode.boundingBox}');

      if (barcode.rawValue != null) {
        value = barcode.rawValue!;
      }
    }
  }
}
