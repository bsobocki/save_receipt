abstract class Dao<T> {
  String get createTableQuery;
  T fromMap(Map<String, dynamic> query);
  Map<String, dynamic> toMap(T object);
  
  List<T> fromList(List<Map<String, dynamic>> query) {
    return query.map((map) => fromMap(map)).toList();
  }
}
