import 'dart:async';

class IterableJoiner<T> extends StreamTransformerBase<Iterable<T>, T> {
  @override
  Stream<T> bind(Stream<Iterable<T>> stream) async* {
    await for(final list in stream) {
      for(final value in list) {
        yield value;
      }
    }
  }
}

class ListJoiner<T> extends StreamTransformerBase<List<T>, T> {
  @override
  Stream<T> bind(Stream<List<T>> stream) {
    return IterableJoiner<T>().bind(stream);
  }
}