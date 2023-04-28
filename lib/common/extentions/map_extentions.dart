part of 'extentions.dart';

extension MapExtentions<K, V> on Map<K, V> {
  bool addNotNull(K key, V? value) {
    if(value == null) return false;
    this[key] = value;
    return true;
  }

  V? pop(K key) => remove(key);
  V? get(K key) => this[key];
  void put(K key, V value) => this[key] = value;

  Map<String, String> toStringMap({
    String Function(K key)? keyMapper,
    String Function(V value)? valueMapper,
  }) {
    keyMapper ??= (k) => k.toString();
    valueMapper ??= (v) => v.toString();

    final result = <String, String>{};

    for (final key in keys) {
      result[keyMapper(key)] = valueMapper(this[key] as V);
    }

    return result;
  }

  // Делает неглубокую копию
  Map<K, V> copy() {
    final result = <K, V>{};
    for(final key in keys) {
      result[key] = this[key] as V;
    }
    return result;
  }
}

extension MapQuery on JsonMap {
  String toUrlEncode() {
    return Uri(queryParameters: toStringMap()).query;
  }

  Map<String, String> toStringMap() {
    final result = <String, String>{};
    for (var key in keys) {
      result[key] = this[key]!.toString();
    }
    return result;
  }

  static Map<String, dynamic> fromQuery(String query) {
    return Uri(query: query).queryParameters;
  }
}