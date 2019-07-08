class DataInfo {
  static final DataInfo _dataInfo = new DataInfo._internal();
  int id;
  String author;
  String created_at;
  String description;
  double thickness;
  int nr_layers;
  List comments;
  factory DataInfo(){return _dataInfo;}
  DataInfo._internal();
}
final dataInfo = DataInfo();
