import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class GoogleBarcodeScanner {
  String code = '';
  final String path;

  GoogleBarcodeScanner({required this.path});

  Future<void> scanImage() async {
    final inputImage = InputImage.fromFilePath(path);
    final List<BarcodeFormat> formats = [BarcodeFormat.all];
    final BarcodeScanner scanner = BarcodeScanner(formats: formats);
    final List<Barcode> barcodes = await scanner.processImage(inputImage);

    for (Barcode barcode in barcodes) {
      final BarcodeFormat format = barcode.format;
      final BarcodeType type = barcode.type;
      print('barcode from $path  :');
      print('format: $format');
      print('type: $type');
      print('raw value: ${barcode.rawValue}');
      print('value: ${barcode.value}');
      print('display value: ${barcode.displayValue}');
      print('bounding box: ${barcode.boundingBox}');

      switch (type) {
        case BarcodeType.wifi:
          final barcodeWifi = barcode.value as BarcodeWifi;
          print('barcode wifi: $barcodeWifi');
          break;
        case BarcodeType.url:
          final barcodeUrl = barcode.value as BarcodeUrl;
          print('barcode url: $barcodeUrl');
          break;
        default:
          print("other type :)");
          break;
      }
    }
  }

  void printBarCode() {}
}
