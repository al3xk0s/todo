part of 'data_source.dart';

/// Функция поиска элемента [value]
typedef LocalDataSourcePredicate<T> = bool Function(T value);

/// Источник хранения коллекции элементов
abstract class ICollectionDataSource<T> {
  FutureOr<List<T>> getAll();
  FutureOr<void> setAll(List<T> values);

  FutureOr<void> add(T value);
  FutureOr<T?> get(LocalDataSourcePredicate<T> predicate);

  FutureOr<void> remove(LocalDataSourcePredicate<T> predicate);
  FutureOr<void> removeAll();
}

/// Источник данных для хранения одиночного класса или значения
abstract class ISingleDataSource<T> {
  FutureOr<T?> get();
  FutureOr<void> set(T value);
  FutureOr<void> remove();
}

abstract class ICollectionStorageDataSource<T, O, S extends IKeyValueStorage<O>> implements ICollectionDataSource<T> {}

/// Источник данных для хранения одиночного класса или значения с использованием хранилищ типа [S] extends [IKeyValueStorage], где [O] - тип в который серилизуются данные
abstract class ISingleStorageDataSource<T, O, S extends IKeyValueStorage<O>> implements ISingleDataSource<T> {}

extension HasValueSingleDataSource on ISingleDataSource {
  FutureOr<bool> has() async => (await get()) != null;
}

extension HasValueCollectionDataSourceExtention<T> on ICollectionDataSource<T> {
  FutureOr<bool> has(LocalDataSourcePredicate<T> predicate) async => (await get(predicate)) != null;
}