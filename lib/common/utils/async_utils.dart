import 'dart:async';

/// Для [FutureOr], которые фактически являются значениями [T]
T synchronize<T>(FutureOr<T> value) => value as T;