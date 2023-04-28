part of 'droplist.dart';

abstract class IDroplistController<T> {
  Rx<DroplistState<T>> get state;

  bool get isEnabled;

  T? get value;
  void setValue(T? value);

  List<T> get values;
  void setValues(Set<T> values);


  void disable();
  void enable();

  void reset();
}


class DroplistController<T> implements IDroplistController<T> {
  DroplistController({Set<T>? values, this.initialValue}) {
    setValues(values ?? const {});
  }

  final T? initialValue;

  @override
  bool get isEnabled => state is DroplistEnabledState<T>;

  @override
  T? get value => _value;

  @override
  List<T> get values => _values.toList();

  @override
  void setValue(T? value) {
    if(value != null && !_containsValue(value)) throw Exception('Unknown value');
    if(_value != null && _value == value) return;
    _value = value;
    _setState(_detectEnableState() ?? _detectDisableState());
  }

  @override
  void reset() {
    setValues(_values.toSet());
  }

  T? _value;
  List<T> _values = [];

  @override
  void enable() {
    final newState = _detectEnableState();
    _setState(newState);
  }
  
  @override
  void disable() {
    final newState = _detectDisableState();
    _setState(newState);
  }
  
  @override
  void setValues(Set<T> values) {
    _values = values.toList();
    setValue(initialValue);
  }
  
  @override
  final Rx<DroplistState<T>> state = Rx<DroplistState<T>>(DroplistDisabledState<T>());

  void _setState(DroplistState<T>? newState) {
    if(newState == null) throw Exception('Невозможно активировать виджет ввиду отсутствия данных');
    state.value = newState;
  }

  DroplistState<T>? _detectEnableState() {
    if(_values.isEmpty) return null;

    if(_validValue) return DroplistEnabledState.withValue(value: value as T, values: values);
    return DroplistEnabledState(values: values);
  }

  DroplistState<T>? _detectDisableState() {
    if(_validValue) return DroplistDisabledState.withValue(value: value as T, values: values);
    return DroplistDisabledState<T>();
  }

  bool get _validValue => _containsValue(_value);

  bool _containsValue(T? value) {
    return value != null && _values.contains(value);
  }
}