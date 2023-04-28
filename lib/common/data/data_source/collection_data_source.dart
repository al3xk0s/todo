part of 'data_source.dart';

class _BaseGroupCollectionStorageDataSource<T> implements ICollectionDataSource<T> {
  _BaseGroupCollectionStorageDataSource({
    required this.uniqueValues,
    required ISingleDataSource<List<T>> singleDataSource,
  }) : _singleDataSource = singleDataSource;

  final bool uniqueValues;
  final ISingleDataSource<List<T>> _singleDataSource;
  
  @override
  FutureOr<List<T>> getAll() async {
    final data = await _singleDataSource.get();
    return data ?? [];
  }

  @override
  FutureOr<void> setAll(List<T> values) {
    final data = uniqueValues ? values.toSet() : values;
    return _singleDataSource.set(data.toList());
  }
  
  @override
  FutureOr<T?> get(LocalDataSourcePredicate<T> predicate) async => (await getAll()).firstWhereOrNull(predicate);
  
  @override
  FutureOr<void> remove(LocalDataSourcePredicate<T> predicate) async {
    final data = await getAll();
    data.removeWhere(predicate);
    return setAll(data);
  }

  @override
  FutureOr<void> removeAll() => _singleDataSource.remove();

  @override
  FutureOr<void> add(T value) async {
    final data = await getAll();
    data.add(value);
    return setAll(data);
  }
}

/// Реализация источника данных для хранения серилизованной коллекции в одном ключе
class GroupCollectionStorageDataSource<T, O, S extends IKeyValueStorage<O>>
  extends _BaseGroupCollectionStorageDataSource<T>
  implements ICollectionStorageDataSource<T, O, S> 
{
  GroupCollectionStorageDataSource({
    required String key,
    required S storage,
    required ICollectionSerializer<T, O> serializer,
    super.uniqueValues = false,
  }) : super(
          singleDataSource: SingleStorageDataSource(
            key: key,
            serializer: serializer,
            storage: storage,
          ),
        );
}

/// Реализация источника данных для хранения серилизованной коллекции в RAM
class GroupCollectionCacheDataSource<T>
  extends _BaseGroupCollectionStorageDataSource<T>
  implements ICollectionDataSource<T> 
{
  GroupCollectionCacheDataSource({
    List<T>? initialValues,
    super.uniqueValues = false,
  }) : super(singleDataSource: SingleCacheDataSource<List<T>>(initialValue: initialValues));
}
