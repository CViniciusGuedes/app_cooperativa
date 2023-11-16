abstract class AbstractEntity<T> {
  factory AbstractEntity.fromMap(Map<String, dynamic> record) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toMap();
}
