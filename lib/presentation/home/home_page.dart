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
import 'package:save_receipt/presentation/home/components/menu.dart';
import 'package:save_receipt/presentation/home/components/navigation_bottom_bar.dart';
import 'package:save_receipt/presentation/home/subsites/receipts.dart';
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
  final String noContentText = "Nothing here yet.";
  final String tipText =
      "Please select an image from gallery to process\nor scan a new one for processing.";
  final ImagePicker picker = ImagePicker();
  String imgPath = "";
  late Future<List<ReceiptDocumentData>> _documentData;
  ReceiptProcessingState _receiptState = ReceiptProcessingState.noAction;
  String databaseStatusText(bool dbExists) =>
      dbExists ? "Databse exists" : "Database doesn't exist";

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
              onDeleteRecipt: ReceiptDatabaseRepository.get.deleteReceipt),
        ),
      ).then(
        (value) {
          _receiptState = ReceiptProcessingState.noAction;
          refreshDocumentData();
        },
      );
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

  Future<int> saveReceipt(ReceiptModel model) async {
    int receiptId = -1;
    var dbRepo = ReceiptDatabaseRepository.get;
    ReceiptDocumentData data;

    if (model.receiptId != null) {
      data = ReceiptDataConverter.toDocumentDataForExistingReceipt(model);
      receiptId = await dbRepo.updateReceipt(data.receipt);
    } else {
      ReceiptData receiptData = ReceiptDataConverter.toReceiptData(model);
      receiptId = await dbRepo.insertReceipt(receiptData);
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

    print("receipt $receiptId saved!!!");

    return receiptId;
  }

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
            future: _documentData, builder: dataItemsListViewBuilder);
    }
  }

  Widget dataItemsListViewBuilder(
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

    return ReceiptsList(
        documentData: dataList,
        onItemSelected: (index) {
          openReceiptPage(ReceiptDataConverter.toReceiptModel(dataList[index]));
        });
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Menu(onRefreshData: refreshDocumentData),
          ),
        ],
      ),
      body: Center(
        child: body,
      ),
      bottomNavigationBar: HomePageNavigationBar(
        onPageSelect: (index) {},
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
