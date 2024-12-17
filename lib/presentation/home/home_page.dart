import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/data/converters/data_converter.dart';
import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/presentation/effect/page_slide_animation.dart';
import 'package:save_receipt/presentation/home/components/expandable_fab.dart';
import 'package:save_receipt/presentation/home/components/loading_animation.dart';
import 'package:save_receipt/presentation/home/components/menu.dart';
import 'package:save_receipt/presentation/home/components/navigation_bottom_bar.dart';
import 'package:save_receipt/presentation/home/controller/home_page_controller.dart';
import 'package:save_receipt/presentation/home/content/receipts/receipts.dart';
import 'package:save_receipt/presentation/receipt/receipt_data_page.dart';

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
  ReceiptProcessingState _processingState = ReceiptProcessingState.noAction;
  String databaseStatusText(bool dbExists) =>
      dbExists ? "Databse exists" : "Database doesn't exist";
  final HomePageController pageController = HomePageController();

  void refreshDocumentData() => setState(() {
        pageController.fetchData();
      });

  @override
  void initState() {
    super.initState();
    pageController.fetchData();
  }

  void setReceiptState(ReceiptProcessingState newState) =>
      setState(() => _processingState = newState);

  void openReceiptPage(ReceiptModel? receipt) {
    if (receipt != null) {
      Navigator.push(
        context,
        SlidePageRoute(
          page: ReceiptDataPage(initialReceipt: receipt),
        ),
      ).then(
        (value) {
          _processingState = ReceiptProcessingState.noAction;
          refreshDocumentData();
        },
      );
    }
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
    if (_processingState == ReceiptProcessingState.noAction) {
      return FutureBuilder(
          future: pageController.documentData,
          builder: dataItemsListViewBuilder);
    }
    return LoadingAnimation(processingState: _processingState);
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
          String? filePath = await pageController.googleScanAndExtractRecipe();
          setReceiptState(ReceiptProcessingState.processing);
          ReceiptModel? receipt = await pageController.processImg(filePath);
          setReceiptState(ReceiptProcessingState.ready);
          await Future.delayed(const Duration(milliseconds: 200));
          if (receipt != null) {
            openReceiptPage(receipt);
          }
        },
        onImageProcessing: () async {
          setReceiptState(ReceiptProcessingState.imageChoosing);
          String? filePath = await pageController.pickImage();
          setReceiptState(ReceiptProcessingState.processing);
          ReceiptModel? receipt = await pageController.processImg(filePath);
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
