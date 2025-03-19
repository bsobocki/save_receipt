import 'package:save_receipt/domain/entities/receipt_object.dart';
import 'package:save_receipt/presentation/receipt/controller/interface/objects_editor_list_controller.dart';

abstract class InfoEditorListController implements ObjectsEditorListController {
  void createFromValueOf(int index);
  void changeToProduct(int index);
  void changeValueType(int index, ReceiptObjectModelType type);
  bool isInfoDouble(int index);
}
