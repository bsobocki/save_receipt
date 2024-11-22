import 'package:save_receipt/source/data/structures/data_field.dart';

class ReceiptEditorModel {
  String? imgPath;
  List<DataFieldModel> data;

  ReceiptEditorModel(this.imgPath) : data = [];
  ReceiptEditorModel.fromData(this.imgPath, this.data);
  void addDataField(DataFieldModel dataField) => data.add(dataField);
}
