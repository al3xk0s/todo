part of 'droplist.dart';

abstract class DroplistState<T> {
  const DroplistState({this.value, required this.enableOnChanged, required this.values});

  final T? value;
  final bool enableOnChanged;
  final List<T> values;
}

class DroplistDisabledState<T> extends DroplistState<T> {
  const DroplistDisabledState() : super(values: const [], enableOnChanged: true);
  const DroplistDisabledState.withValue ({required T value, required super.values}) : super(value: value, enableOnChanged: false);
}

class DroplistEnabledState<T> extends DroplistState<T> {
  const DroplistEnabledState({required super.values}) : super(enableOnChanged: true);
  const DroplistEnabledState.withValue({required T value, required super.values}) : super(value: value, enableOnChanged: true);
}