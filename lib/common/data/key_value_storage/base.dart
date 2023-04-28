part of 'key_value_storage.dart';

typedef KeyValueStorageInstanceFactory = IStringKeyValueStorage Function();

/// Интерфейс представляющий хранилище вида `ключ` [String] - `значение` [V]
abstract class IKeyValueStorage<V> {
  FutureOr<V> read(String key);
  FutureOr<void> write(String key, V value);
  FutureOr<void> delete(String key);
  FutureOr<bool> contains(String key);
}

/// Интерфейс представляющий хранилище вида `ключ` - `значение` в строковом виде
typedef IStringKeyValueStorage = IKeyValueStorage<String>;

/// Расширение try вариаций методов для любого производного типа, реализующего интерфейс [IKeyValueStorage]
extension TryKeyValueStorageExtentions<V> on IKeyValueStorage<V> {
  FutureOr<V?> tryRead(String key) async {
    try {
      return await read(key);
    } catch (_) {
      return null;
    }
  }

  FutureOr<bool> tryWrite(String key, V value) async {
    try {
      await write(key, value);
      return true;
    } catch (_) {
      return false;
    }
  }

  FutureOr<bool> tryDelete(String key) async {
    try {
      await delete(key);
      return true;
    } catch (_) {
      return false;
    }
  }
}
