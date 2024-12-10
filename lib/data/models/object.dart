abstract class ObjectData {
  final int? id;
  final String name;

  const ObjectData({
    this.id,
    required this.name,
  });

  ObjectData copyWith({int? id, String? name});
}
