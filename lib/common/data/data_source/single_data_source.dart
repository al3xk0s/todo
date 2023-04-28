part of 'data_source.dart';

/// Реализация источника данных с операциями над одиночным значением в паре с хранилищем
class SingleStorageDataSource<T, O, S extends IKeyValueStorage<O>> implements ISingleStorageDataSource<T, O, S> {
  const SingleStorageDataSource({required this.key, required this.serializer, required this.storage});

  final String key;
  final ISerializer<T, O> serializer;
  final S storage;

  @override
  FutureOr<T?> get() async {
    if (!await storage.contains(key)) return null;
    return serializer.deserialize(await storage.read(key));
  }

  @override
  FutureOr<void> remove() => storage.delete(key);

  @override
  FutureOr<void> set(T value) => storage.write(key, serializer.serialize(value));
}

class SingleCacheDataSource<T> implements ISingleDataSource<T> {
  SingleCacheDataSource({ T? initialValue }) : _value = initialValue;

  T? _value;

  @override
  FutureOr<T?> get() => _value;

  @override
  FutureOr<void> remove() => _value = null;

  @override
  FutureOr<void> set(value) => _value = value;
}
