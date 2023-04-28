part of 'serializable.dart';

/// Интерфейс маппера значений типа [T] в формат `json` - объектов и обратно
abstract class IJsonMapper<T> {
  JsonMap toMap(T value);
  T fromMap(JsonMap data);
}
