import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/data/converters/data_converter.dart';
import 'package:save_receipt/data/models/document.dart';
import 'package:save_receipt/data/models/entities/product.dart';
import 'package:save_receipt/data/models/entities/receipt.dart';
import 'package:save_receipt/domain/entities/receipt.dart';
import 'package:save_receipt/presentation/home/components/expandable_fab.dart';
import 'package:save_receipt/presentation/home/components/loading_animation.dart';
import 'package:save_receipt/presentation/home/components/home_page_navigation_bar.dart';
import 'package:save_receipt/presentation/home/components/topbar/topbar.dart';
import 'package:save_receipt/presentation/home/content/products/products.dart';
import 'package:save_receipt/presentation/home/controller/home_page_controller.dart';
import 'package:save_receipt/presentation/home/content/receipts/receipts.dart';
import 'package:save_receipt/services/document/scan/google_scan.dart';
import 'package:save_receipt/services/images/image_operations.dart';

const String noContentText = "Nothing here yet.";
const String tipText =
    "Select an image from gallery or scan a new one\nto start processing.";

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({super.key, required this.title});

  final themeController = Get.find<ThemeController>();
  final pageController = Get.put(HomePageController());

  Widget noContentTextInfo(bool dbExists) => Column(
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

  Widget receiptsList(List<ReceiptDocumentData> receiptsDocuments) =>
      ReceiptsList(
        documentData: receiptsDocuments,
        onItemSelected: (index) async {
          pageController.resetSearchQuery();
          await pageController.openReceiptPage(
            receiptModel:
                ReceiptDataConverter.toReceiptModel(receiptsDocuments[index]),
          );
        },
        onItemDeleted: (index) async {
          ReceiptData receipt = receiptsDocuments[index].receipt;
          if (receipt.id != null) {
            await pageController.deleteReceipt(receipt.id!);
            await pageController.fetchData();
          }
        },
      );

  Widget productsList(List<ProductData> products) => ProductsList(
        productsData: products,
        onItemSelected: (index) async {
          int receiptId = products[index].receiptId;
          ReceiptDocumentData? data =
              pageController.documentData.firstWhereOrNull(
            (element) => element.receipt.id == receiptId,
          );
          if (data != null) {
            pageController.resetSearchQuery();
            await pageController.openReceiptPage(
              receiptModel: ReceiptDataConverter.toReceiptModel(data),
            );
          }
        },
      );

  Widget _buildBody() {
    if (pageController.processingState.value !=
        ReceiptProcessingState.noAction) {
      return LoadingAnimation(
        processingState: pageController.processingState.value,
      );
    }

    var filteredReceiptsDocuments = pageController.filteredData;
    var filteredProducts = pageController.filteredProducts;

    switch (pageController.selectedPage.value) {
      case NavigationPages.receipts:
        return receiptsList(filteredReceiptsDocuments);
      case NavigationPages.products:
        return productsList(filteredProducts);
    }
  }

  Widget _buildExpandableFAB() => ExpandableFloatingActionButton(
        onDocumentScanning: () => pageController.processDataFromReceipt(
          getDocumentPathCallback: googleScanAndExtractRecipe,
        ),
        onImageProcessing: () => pageController.processDataFromReceipt(
          getDocumentPathCallback: pickImage,
        ),
        onNewReceiptAdding: () => pageController.openReceiptPage(
          receiptModel: const ReceiptModel(
            title: 'Receipt',
            objects: [],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: HomepageTopbar(
          title: title,
          searchTextController: pageController.searchTextController,
          onRefreshData: pageController.fetchData,
        ),
        body: _buildBody(),
        bottomNavigationBar: HomePageNavigationBar(
          selectedPage: pageController.selectedPage.value,
          onPageSelect: (page) => pageController.selectedPage.value = page,
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: _buildExpandableFAB(),
      ),
    );
  }
}
