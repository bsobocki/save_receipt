import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_receipt/color/themes/main_theme.dart';
import 'package:save_receipt/screen/effect/page_slide_animation.dart';
import 'package:save_receipt/screen/home/components/expandable_fab.dart';
import 'package:save_receipt/screen/receipt_data/receipt_data_page.dart';
import 'package:save_receipt/source/data/connect_data.dart';
import 'package:save_receipt/source/data/parse_data.dart';
import 'package:save_receipt/source/data/structures/connected_data.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';
import 'package:save_receipt/source/document_operations/scan/google_read_text_from_image.dart';
import 'package:save_receipt/source/document_operations/scan/google_scan.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker picker = ImagePicker();
  String imageScannerText = "Please select an image to scan.";
  String imageProcessingText = "Please select an image to process.";
  String imgPath = "";

  Widget getImg() {
    if (imgPath.isEmpty) {
      return Image.asset('assets/no_image.jpg');
    } else {
      return Image.file(File(imgPath));
    }
  }

  Future<String?> _pickImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    return file?.path;
  }

  Future<String?> _googleScanAndExtractRecipe() async {
    return await scanRecipe();
  }

  Future<Receipt?> _processImage({bool scan = false}) async {
    String? filePath =
        scan ? await _googleScanAndExtractRecipe() : await _pickImage();
    if (filePath != null) {
      List<TextLine> textLines = await processImage(filePath);
      List<ConnectedTextLines> connectedLines =
          getConnectedTextLines(textLines);
      List<ReceiptObject> parsedObjects = parseData(connectedLines);
      return Receipt(
        imgPath: filePath,
        objects: parsedObjects,
      );
    }
    return null;
  }

  void openReceiptPage(Receipt? receipt) {
    if (receipt != null) {
      Navigator.push(
        context,
        SlidePageRoute(
          page: ReceiptDataPage(
            initialReceipt: receipt,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: mainTheme.gradient,
          ),
        ),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              imageProcessingText,
              style: TextStyle(color: mainTheme.mainColor),
            ),
            Text(
              imageScannerText,
              style: TextStyle(color: mainTheme.mainColor),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.adb_outlined), label: 'label'),
          BottomNavigationBarItem(
              icon: Icon(Icons.adobe_rounded), label: 'label'),
        ],
        selectedItemColor: mainTheme.mainColor,
        unselectedItemColor: mainTheme.unselectedColor,
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFloatingActionButton(
        onDocumentScanning: () async {
          Receipt? receipt = await _processImage(scan: true);
          if (receipt != null) {
            openReceiptPage(receipt);
          }
        },
        onImageProcessing: () async {
          Receipt? receipt = await _processImage(scan: false);
          if (receipt != null) {
            openReceiptPage(receipt);
          }
        },
      ),
    );
  }
}
