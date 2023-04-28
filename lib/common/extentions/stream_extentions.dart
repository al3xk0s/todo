part of 'extentions.dart';

extension StreamExtentions on Stream<List<int>> {
  Future<String> toStringEncoded({Encoding encoding = utf8}) {
    final completer = Completer<String>();
    final contents = StringBuffer();

    transform(encoding.decoder).listen(
      (decodedString) => contents.write(decodedString),
      onDone: () => completer.complete(contents.toString()),
    );

    return completer.future;
  }

  Future<List<int>> bytesJoin() => transform(ListJoiner()).toList();
}