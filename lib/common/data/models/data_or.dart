import 'dart:async';

import 'package:todo/common/utils/async_utils.dart';

/// Класс для представления данных или неудачи
class DataOr<D, F> {
  bool get isData => _data != null;
  bool get isFailure => _failure != null;

  D asData() => _data!;
  F asFailure() => _failure!;

  final D? _data;
  final F? _failure;

  const DataOr.data(D data) : _data = data, _failure = null;
  const DataOr.failure(F failure) : _failure = failure, _data = null;

  FutureOr<void> asyncHandle({
    required FutureOr<void> Function(D data) onData,
    required FutureOr<void> Function(F failure) onFailure,
  }) async {
    if(isData) return onData(_data as D);
    return onFailure(_failure as F);
  }

  void handle({
    required void Function(D data) onData,
    required void Function(F failure) onFailure,
  }) => synchronize(asyncHandle(onData: onData, onFailure: onFailure));
}

/// Класс для предоставления списка данных или неудачи
class ListOr<T, F> extends DataOr<List<T>, F> {
  const ListOr.values(List<T> values) : super.data(values);
  const ListOr.failure(F failure) : super.failure(failure);
}

class BoolOr<F> extends DataOr<bool, F> {
  const BoolOr.values(value) : super.data(value);
  const BoolOr.failure(F failure) : super.failure(failure);

  bool get isSuccess => isData && asData();
}
