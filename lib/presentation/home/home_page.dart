import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/data/converters/data_converter.dart';
import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/data/models/entities/product.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/presentation/effect/page_slide_animation.dart';
import 'package:save_receipt/presentation/home/components/expandable_fab.dart';
import 'package:save_receipt/presentation/home/components/loading_animation.dart';
import 'package:save_receipt/presentation/home/components/home_page_navigation_bar.dart';
import 'package:save_receipt/presentation/home/components/topbar.dart';
import 'package:save_receipt/presentation/home/content/products/products.dart';
import 'package:save_receipt/presentation/home/controller/home_page_controller.dart';
import 'package:save_receipt/presentation/home/content/receipts/receipts.dart';
import 'package:save_receipt/presentation/receipt/receipt_data_page.dart';
import 'package:save_receipt/services/data_processing/parse_data.dart';

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
  final HomePageController pageController = HomePageController();
  String dataFilter = "";
  final String noContentText = "Nothing here yet.";
  final String tipText =
      "Select an image from gallery or scan a new one\nto start processing.";
  ReceiptProcessingState _processingState = ReceiptProcessingState.noAction;
  NavigationPages _selectedPage = NavigationPages.receipts;

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

  void openReceiptPage({ReceiptModel? receiptModel, AllValuesModel? allValuesModel}) {
    if (receiptModel != null) {
      Navigator.push(
        context,
        SlidePageRoute(
          page: ReceiptDataPage(initialReceipt: receiptModel, allValuesModel: allValuesModel),
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
    List<ProductData> productsList =
        dataList.expand((data) => data.products).toList();

    List<ReceiptDocumentData> filteredData = dataList;
    List<ProductData> filteredProducts = productsList;

    if (dataFilter.isNotEmpty) {
      filteredData = dataList.where((data) {
        return data.products.any((product) =>
            product.name.toLowerCase().contains(dataFilter.toLowerCase()));
      }).toList();

      filteredProducts = productsList
          .where(
            (product) =>
                product.name.toLowerCase().contains(dataFilter.toLowerCase()),
          )
          .toList();
    }

    switch (_selectedPage) {
      case NavigationPages.receipts:
        return ReceiptsList(
          documentData: filteredData,
          onItemSelected: (index) {
            ReceiptModel receiptModel =
                ReceiptDataConverter.toReceiptModel(dataList[index]);
            openReceiptPage(receiptModel: receiptModel);
          },
        );
      case NavigationPages.products:
        return ProductsList(
          productsData: filteredProducts,
          onItemSelected: (index) {
            print('Selected product: ${productsList[index]}');
          },
        );
    }
  }

  Future<void> processDataFromReceipt(Future<String?> Function() getDocumentPathCallback) async {
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
                  objects: processedDataModel.receiptObjectModels),
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
        onSearchTextChanged: (String newValue) {
          print("searching: $newValue");
          setState(() => dataFilter = newValue);
        },
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
          await processDataFromReceipt(pageController.googleScanAndExtractRecipe);
        },
        onImageProcessing: () async {
          await processDataFromReceipt(pageController.pickImage);
        },
      ),
    );
  }
}
