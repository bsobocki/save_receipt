import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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

enum ReceiptState {
  noAction,
  browse,
  opening,
  processing,
  imageChoosing,
  ready
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker picker = ImagePicker();
  String imageScannerText = "Please select an image to scan.";
  String imageProcessingText = "Please select an image to process.";
  String imgPath = "";
  ReceiptState _receiptState = ReceiptState.noAction;

  void setReceiptState(ReceiptState newState) =>
      setState(() => _receiptState = newState);

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

  Future<Receipt?> _processImage(String? filePath) async {
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
      ).then((value) => setReceiptState(ReceiptState.noAction),);
    }
  }

  get choosingContent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.dotsTriangle(
              color: mainTheme.mainColor, size: 100.0),
          Text("Choose Image to process",
              style: TextStyle(color: mainTheme.mainColor))
        ],
      );

  get readyContent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Icon(Icons.check_circle_outlined, color: mainTheme.mainColor, size: 100.0),
          Text("Ready!", style: TextStyle(color: mainTheme.mainColor))
        ],
      );

  get processingContent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
              color: mainTheme.mainColor, size: 100.0),
          Text('Processing Image...',
              style: TextStyle(color: mainTheme.mainColor)),
        ],
      );

  get mainContent => Column(
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
      );

  get body {
    switch (_receiptState) {
      case ReceiptState.processing:
        return processingContent;
      case ReceiptState.imageChoosing:
        return choosingContent;
      case ReceiptState.ready:
        return readyContent;
      default:
        return mainContent;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: body,
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
          setReceiptState(ReceiptState.imageChoosing);
          String? filePath = await _googleScanAndExtractRecipe();
          setReceiptState(ReceiptState.processing);
          Receipt? receipt = await _processImage(filePath);
          setReceiptState(ReceiptState.ready);
          await Future.delayed(const Duration(milliseconds: 300));
          if (receipt != null) {
            openReceiptPage(receipt);
          }
        },
        onImageProcessing: () async {
          setReceiptState(ReceiptState.imageChoosing);
          String? filePath = await _pickImage();
          setReceiptState(ReceiptState.processing);
          Receipt? receipt = await _processImage(filePath);
          setReceiptState(ReceiptState.ready);
          await Future.delayed(const Duration(milliseconds: 300));
          if (receipt != null) {
            openReceiptPage(receipt);
          }
        },
      ),
    );
  }
}