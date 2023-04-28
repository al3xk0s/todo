part of 'key_value_storage.dart';

/// Stateless реализация хранилища вида `ключ` - `значение`
class CacheKeyValueStorage<T> implements IKeyValueStorage<T> {
  CacheKeyValueStorage([Map<String, T>? initialData]) : _values = initialData?.copy() ?? {};

  final Map<String, T> _values;

  @override
  FutureOr<bool> contains(String key) => _values.containsKey(key);

  @override
  FutureOr<void> delete(String key) => _values.remove(key);

  @override
  FutureOr<T> read(String key) => _values.get(key)!;

  @override
  FutureOr<void> write(String key, T value) => _values[key] = value;
}
