import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/data/converters/data_converter.dart';
import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/data/models/database_entities.dart';
import 'package:save_receipt/data/repositories/database_repository.dart';
import 'package:save_receipt/presentation/effect/page_slide_animation.dart';
import 'package:save_receipt/presentation/home/components/expandable_fab.dart';
import 'package:save_receipt/presentation/receipt/receipt_data_page.dart';
import 'package:save_receipt/data/connect_data.dart';
import 'package:save_receipt/data/parse_data.dart';
import 'package:save_receipt/domain/entities/connected_data.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/services/document/scan/google_read_text_from_image.dart';
import 'package:save_receipt/services/document/scan/google_scan.dart';

enum ReceiptProcessingState {
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
  ReceiptProcessingState _receiptState = ReceiptProcessingState.noAction;
  final ImagePicker picker = ImagePicker();
  String databaseStatusText(bool dbExists) =>
      dbExists ? "Databse exists" : "Database doesn't exist";
  String noContentText = "Nothing here yet.";
  String tipText =
      "Please select an image from gallery\n to scan a new one for processing.";
  String imgPath = "";
  late Future<List<ReceiptDocumentData>> _documentData;

  void refreshDocumentData() {
    setState(() {
      _documentData = ReceiptDatabaseRepository.get.getAllDocumentDatas();
    });
  }

  @override
  void initState() {
    super.initState();
    _documentData = ReceiptDatabaseRepository.get.getAllDocumentDatas();
  }

  void setReceiptState(ReceiptProcessingState newState) =>
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

  Future<ReceiptModel?> _processImage(String? filePath) async {
    if (filePath != null) {
      List<TextLine> textLines = await processImage(filePath);
      List<ConnectedTextLines> connectedLines =
          getConnectedTextLines(textLines);
      List<ReceiptObjectModel> parsedObjects = parseData(connectedLines);
      return ReceiptModel(
        imgPath: filePath,
        objects: parsedObjects,
      );
    }
    return null;
  }

  void openReceiptPage(ReceiptModel? receipt) {
    if (receipt != null) {
      Navigator.push(
        context,
        SlidePageRoute(
          page: ReceiptDataPage(
            initialReceipt: receipt,
            onSaveReceipt: saveReceipt,
          ),
        ),
      ).then(
        (value) {
          _receiptState = ReceiptProcessingState.noAction;
          refreshDocumentData();
        },
      );
    }
  }

  void saveReceipt(ReceiptModel model) async {
    var dbRepo = ReceiptDatabaseRepository.get;
    ReceiptDocumentData data;

    if (model.receiptId != null) {
      data = ReceiptDataConverter.toDocumentDataForExistingReceipt(model);
      await dbRepo.updateReceipt(data.receipt);
    } else {
      ReceiptData receiptData = ReceiptDataConverter.toReceiptData(model);
      int receiptId = await dbRepo.insertReceipt(receiptData);
      data = ReceiptDataConverter.toDocumentData(model, receiptId);
    }

    for (ProductData prod in data.products) {
      await dbRepo.insertProduct(prod);
    }
    for (InfoData info in data.infos) {
      await dbRepo.insertInfo(info);
    }
    if (data.shop != null) {
      await dbRepo.insertShop(data.shop!);
    }

    print("receipt saved!!!");
    print("saved document: ");
    print(data);
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
          Icon(Icons.check_circle_outlined,
              color: mainTheme.mainColor, size: 100.0),
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

  Widget textInfoContent(bool dbExists) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            databaseStatusText(dbExists),
            style: TextStyle(color: mainTheme.mainColor),
          ),
          Text(
            noContentText,
            style: TextStyle(color: mainTheme.mainColor),
          ),
          Text(
            tipText,
            style: TextStyle(color: mainTheme.mainColor),
            textAlign: TextAlign.center,
          ),
        ],
      );

  get body {
    switch (_receiptState) {
      case ReceiptProcessingState.processing:
        return processingContent;
      case ReceiptProcessingState.imageChoosing:
        return choosingContent;
      case ReceiptProcessingState.ready:
        return readyContent;
      default:
        return FutureBuilder(
            future: _documentData, builder: receiptListViewBuilder);
    }
  }

  Widget receiptListViewBuilder(
      BuildContext context, AsyncSnapshot<List<ReceiptDocumentData>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: LoadingAnimationWidget.newtonCradle(
          color: mainTheme.mainColor,
          size: 100.0,
        ),
      );
    } else if (!snapshot.hasData) {
      return textInfoContent(false);
    } else if (snapshot.data!.isEmpty) {
      return textInfoContent(true);
    }

    List<ReceiptDocumentData> dataList = snapshot.data!;

    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              color: mainTheme.mainColor,
              child: Text(dataList[index].toString())),
        );
      },
    );
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
        actions: [
          IconButton(
              onPressed: () {
                ReceiptDatabaseRepository.get.deleteDb();
                refreshDocumentData();
              },
              icon: const Icon(Icons.playlist_remove_rounded)),
          IconButton(
              onPressed: refreshDocumentData, icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: ReceiptDatabaseRepository.get.printDatabase,
              icon: const Icon(Icons.text_snippet_sharp)),
        ],
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
          setReceiptState(ReceiptProcessingState.imageChoosing);
          String? filePath = await _googleScanAndExtractRecipe();
          setReceiptState(ReceiptProcessingState.processing);
          ReceiptModel? receipt = await _processImage(filePath);
          setReceiptState(ReceiptProcessingState.ready);
          await Future.delayed(const Duration(milliseconds: 200));
          if (receipt != null) {
            openReceiptPage(receipt);
          }
        },
        onImageProcessing: () async {
          setReceiptState(ReceiptProcessingState.imageChoosing);
          String? filePath = await _pickImage();
          setReceiptState(ReceiptProcessingState.processing);
          ReceiptModel? receipt = await _processImage(filePath);
          setReceiptState(ReceiptProcessingState.ready);
          await Future.delayed(const Duration(milliseconds: 300));
          if (receipt != null) {
            openReceiptPage(receipt);
          }
        },
      ),
    );
  }
}
