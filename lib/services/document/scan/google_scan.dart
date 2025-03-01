import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

Future<String?> googleScanAndExtractRecipe() async {
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
    print('Error scanning document: $err');
  }

  return null;
}
