part of 'serializable.dart';

/// Интерфейс для сериализации / десериализации коллекций [I] элементов в тип [O]
typedef ICollectionSerializer<I, O> = ISerializer<List<I>, O>;

/// Реализация сериализации / десериализации коллекции [T] элементов с использованием формата `json`
class JsonCollectionSerializer<T> implements ICollectionSerializer<T, String> {
  const JsonCollectionSerializer(this.elementSerializer);

  final ISerializer<T, dynamic> elementSerializer;

  @override
  List<T> deserialize(String rawData) => fromJsonList(jsonDecode(rawData) as List, fromJson: (e) => elementSerializer.deserialize(e));

  @override
  String serialize(Iterable<T> value) => jsonEncode(toJsonList<T>(value, toJson: elementSerializer.serialize));

  static List<T> fromJsonList<T>(Iterable<dynamic> data, {required T Function(dynamic data) fromJson})
  => data.map((e) => fromJson(e)).toList();

  static List<dynamic> toJsonList<T>(Iterable<T> data, {required dynamic Function(T element) toJson})
  => data.map(toJson).toList();
}
