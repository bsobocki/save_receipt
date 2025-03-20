
import 'package:save_receipt/core/utils/enums.dart';

enum NavigationPages { receipts, products }

extension NavigationPagesExtension on NavigationPages {
  String get label => enumLabel(this);
}

enum ReceiptProcessingState {
  noAction,
  browse,
  opening,
  processing,
  imageChoosing,
  barcodeExtracting,
  documentFormatting,
  ready,
  fetchingData,
  error
}