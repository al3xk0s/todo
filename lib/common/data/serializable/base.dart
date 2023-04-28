part of 'serializable.dart';

typedef JsonMap = Map<String, dynamic>;

abstract class ISerializable<T> {
  T serialize();
}

/// Интерфейс, который обязаны реализовать серилизуемые в `json` типы данных
typedef IJsonSerializable = ISerializable<JsonMap>;
