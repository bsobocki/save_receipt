T enumFromString<T>(String value, List<T> enumValues) {
  return enumValues.firstWhere(
    (type) => type.toString().split('.').last == value,
    orElse: () => throw Exception('Enum value not found'),
  );
}

String enumLabel<T>(T value) {
  return value.toString().split('.').last;
}