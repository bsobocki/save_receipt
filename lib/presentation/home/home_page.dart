import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/data/converters/data_converter.dart';
import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/data/models/entities/product.dart';
import 'package:save_receipt/data/models/entities/receipt.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/presentation/common/effect/page_slide_animation.dart';
import 'package:save_receipt/presentation/home/components/expandable_fab.dart';
import 'package:save_receipt/presentation/home/components/loading_animation.dart';
import 'package:save_receipt/presentation/home/components/home_page_navigation_bar.dart';
import 'package:save_receipt/presentation/home/components/topbar.dart';
import 'package:save_receipt/presentation/home/content/products/products.dart';
import 'package:save_receipt/presentation/home/controller/home_page_controller.dart';
import 'package:save_receipt/presentation/home/content/receipts/receipts.dart';
import 'package:save_receipt/presentation/receipt/receipt_data_page.dart';
import 'package:save_receipt/services/data_processing/parse_data.dart';
import 'package:save_receipt/services/document/scan/google_barcode_scan.dart';

enum ReceiptProcessingState {
  noAction,
  browse,
  opening,
  processing,
  imageChoosing,
  ready,
  error
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String noContentText = "Nothing here yet.";
  final ThemeController themeController = Get.find();
  final HomePageController pageController = HomePageController();
  final TextEditingController searchingTextController = TextEditingController();
  final String tipText =
      "Select an image from gallery or scan a new one\nto start processing.";
  NavigationPages _selectedPage = NavigationPages.receipts;
  ReceiptProcessingState _processingState = ReceiptProcessingState.noAction;

  void refreshDocumentData() => setState(() {
        pageController.fetchData();
      });

  @override
  void initState() {
    super.initState();
    pageController.fetchData();
  }

  void setSearchingText(final String newText) =>
      searchingTextController.text = newText;

  void setReceiptState(ReceiptProcessingState newState) =>
      setState(() => _processingState = newState);

  void openReceiptPage({
    ReceiptModel? receiptModel,
    AllValuesModel? allValuesModel,
  }) async {
    if (receiptModel != null) {
      ReceiptBarcodeData? barcodeData;
      if (receiptModel.imgPath != null) {
        GoogleBarcodeScanner scanner =
            GoogleBarcodeScanner(receiptModel.imgPath!);
        setReceiptState(ReceiptProcessingState.processing);
        await scanner.scanImage();
        setReceiptState(ReceiptProcessingState.ready);
        barcodeData = scanner.data;
      }
      if (mounted) {
        Navigator.push(
          context,
          SlidePageRoute(
            page: ReceiptDataPage(
              initialReceipt: receiptModel,
              allValuesModel: allValuesModel,
              barcodeData: barcodeData,
            ),
          ),
        ).then(
          (value) {
            _processingState = ReceiptProcessingState.noAction;
            refreshDocumentData();
          },
        );
      }
    }
  }

  Widget textInfoContent(bool dbExists) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            noContentText,
            style: TextStyle(color: themeController.theme.mainColor),
          ),
          Text(
            tipText,
            style: TextStyle(color: themeController.theme.mainColor),
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
    BuildContext context,
    AsyncSnapshot<List<ReceiptDocumentData>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: LoadingAnimationWidget.newtonCradle(
          color: themeController.theme.mainColor,
          size: 100.0,
        ),
      );
    } else if (!snapshot.hasData) {
      return textInfoContent(false);
    } else if (snapshot.data!.isEmpty) {
      return textInfoContent(true);
    }

    List<ReceiptDocumentData> dataList = snapshot.data!;
    List<ProductData> productsList =
        dataList.expand((data) => data.products).toList();

    List<ReceiptDocumentData> filteredData = dataList;
    List<ProductData> filteredProducts = productsList;

    String dataFilter = searchingTextController.text;

    if (dataFilter.isNotEmpty) {
      filteredData = dataList.where((data) {
        return data.products.any((product) =>
            product.name.toLowerCase().contains(dataFilter.toLowerCase()));
      }).toList();

      filteredProducts = productsList
          .where((product) =>
              product.name.toLowerCase().contains(dataFilter.toLowerCase()))
          .toList();
    }

    switch (_selectedPage) {
      case NavigationPages.receipts:
        return ReceiptsList(
          documentData: filteredData,
          onItemSelected: (index) {
            setSearchingText("");
            openReceiptPage(
              receiptModel:
                  ReceiptDataConverter.toReceiptModel(filteredData[index]),
            );
          },
          onItemDeleted: (index) async {
            ReceiptData receipt = filteredData[index].receipt;
            if (receipt.id != null) {
              await pageController.deleteReceipt(receipt.id!);
              refreshDocumentData();
            }
          },
        );

      case NavigationPages.products:
        return ProductsList(
          productsData: filteredProducts,
          onItemSelected: (index) {
            int receiptId = filteredProducts[index].receiptId;
            ReceiptDocumentData? data = dataList
                .firstWhereOrNull((element) => element.receipt.id == receiptId);
            if (data != null) {
              setSearchingText("");
              openReceiptPage(
                receiptModel: ReceiptDataConverter.toReceiptModel(data),
              );
            }
          },
        );
    }
  }

  Future<void> processDataFromReceipt(
      Future<String?> Function() getDocumentPathCallback) async {
    setReceiptState(ReceiptProcessingState.imageChoosing);
    String? filePath = await getDocumentPathCallback();
    setReceiptState(ReceiptProcessingState.processing);
    ProcessedDataModel? processedDataModel =
        await pageController.processImg(filePath);
    if (processedDataModel != null) {
      setReceiptState(ReceiptProcessingState.ready);
      await Future.delayed(const Duration(milliseconds: 200));
      openReceiptPage(
        receiptModel: ReceiptModel(
          imgPath: filePath,
          objects: processedDataModel.receiptObjectModels,
        ),
        allValuesModel: processedDataModel.allValuesModel,
      );
    } else {
      setReceiptState(ReceiptProcessingState.error);
      await Future.delayed(const Duration(milliseconds: 200));
    }
    setReceiptState(ReceiptProcessingState.noAction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageTopbar(
        onRefreshData: refreshDocumentData,
        title: widget.title,
        onSearchTextChanged: (String filter) =>
            setState(() => setSearchingText(filter)),
        searchingTextController: searchingTextController,
      ),
      body: Center(
        child: body,
      ),
      bottomNavigationBar: HomePageNavigationBar(
        onPageSelect: (NavigationPages page) {
          setState(() {
            _selectedPage = page;
          });
        },
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFloatingActionButton(
        onDocumentScanning: () async {
          await processDataFromReceipt(
              pageController.googleScanAndExtractRecipe);
        },
        onImageProcessing: () async {
          await processDataFromReceipt(pageController.pickImage);
        },
        onNewReceiptAdding: () {
          openReceiptPage(
            receiptModel: const ReceiptModel(objects: []),
          );
        },
      ),
    );
  }
}
