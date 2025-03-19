import 'package:save_receipt/presentation/receipt/controller/interface/objects_editor_list_controller.dart';

abstract class ProductsEditorListController implements ObjectsEditorListController {
  void changeToInfo(int index);
}
