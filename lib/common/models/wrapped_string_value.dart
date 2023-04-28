abstract class WrappedStringValue {
  const WrappedStringValue(this.value);

  final String value;

  @override
  String toString() {
    return value;
  }

  static T parseOfValues<T extends WrappedStringValue>(String value, List<T> values) {
    final candidates = values.where((element) => element.value == value);
    if(candidates.isEmpty) throw Exception('Value $value isn\'t $T');
    return candidates.first;
  }
}