part of 'serializable.dart';

/// Интерфейс сериализации / десериализации [T] элемента с использованием формата `json`
abstract class IJsonSerializer<T> implements IJsonMapper<T>, ISerializer<T, String> {}

/// Базовый класс сериализации / десериализации [T] элемента с использованием формата `json`
abstract class BaseJsonSerializer<T> implements IJsonSerializer<T> {
  const BaseJsonSerializer();

  @override
  T deserialize(String rawData) => fromMap(jsonDecode(rawData));

  @override
  String serialize(T value) => jsonEncode(toMap(value));
}

/// Реализация сериализации / десериализации [T] элемента с использованием формата `json` на `callback` - функциях
class JsonSerializer<T> extends BaseJsonSerializer<T> implements IJsonSerializer<T> {
  late final Transformer<T, JsonMap> _toMap;
  final Transformer<JsonMap, T> _fromMap;

  JsonSerializer({
    required JsonMap Function(T value) toMap,
    required T Function(JsonMap data) fromMap,
  }) : _fromMap = fromMap, _toMap = toMap;

  /// Для объектов типа [T], реализующих интерфейс [IJsonSerializable]
  static JsonSerializer<T> serializable<T extends IJsonSerializable>({
    required T Function(JsonMap data) builder,
  }) => JsonSerializer(
      toMap: (value) => value.serialize(),
      fromMap: builder,
    );

  @override
  T fromMap(JsonMap data) => _fromMap(data);

  @override
  JsonMap toMap(T value) => _toMap(value);
}
