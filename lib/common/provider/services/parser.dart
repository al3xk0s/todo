part of '../provider.dart';

/// Псевдоним фунции - парсера
typedef ResponseParserFunction<T> = FutureOr<T> Function(HttpClientResponse response);

/// Неявно реализует [ResponseParserFunction]
abstract class ResponseParser<T> {
  // ignore: unused_element
  const ResponseParser._();

  FutureOr<T> call(HttpClientResponse response);

  /// Парсит [HttpClientResponse] в [T]
  factory ResponseParser(FutureOr<T> Function(HttpClientResponse response) parse)
    => _CallbackParser<T>(parse);

  /// Парсит ответ из байт в кодировке [responseEncoding] в строку, а из строки в [T]
  factory ResponseParser.fromString(FutureOr<T> Function(String rawResponse) parse, {Encoding responseEncoding = utf8})
    => _StepParser((data) => data.toStringEncoded(encoding: responseEncoding), parse);

  /// Парсит ответ из байт в кодировке [responseEncoding] в строку и возвращает её
  static ResponseParser<String> string({Encoding responseEncoding = utf8})
  => ResponseParser.fromString((rawResponse) => rawResponse, responseEncoding: responseEncoding);

  /// Парсит ответ из байт в кодировке [responseEncoding] в строку и десерилизует её через [serializer]
  factory ResponseParser.stringSerializer(ISerializer<T, String> serializer, {Encoding responseEncoding = utf8}) =>
    ResponseParser.fromString((rawResponse) => serializer.deserialize(rawResponse), responseEncoding: responseEncoding);

  /// Парсит ответ из байт в кодировке [responseEncoding] в строку, преобразует её в `jsonObject`, а его в [T]
  factory ResponseParser.fromJson(FutureOr<T> Function(dynamic json) parse, {Encoding responseEncoding = utf8})
    => _StepParser((data) => data.toJson(responseEncoding: responseEncoding), parse);

  /// Парсит ответ из байт в кодировке [responseEncoding] в строку, преобразует её в `jsonObject`, а его в [List] [T]
  static ResponseParser<List<T>> fromJsonList<T>(T Function(dynamic json) parseElement, {Encoding responseEncoding = utf8})
    => ResponseParser.fromJson((json) => JsonCollectionSerializer.fromJsonList(json, fromJson: parseElement), responseEncoding: responseEncoding);

  /// Парсит ответ из байт в кодировке [responseEncoding] в строку, преобразует её в `jsonObject` и возвращает его
  static ResponseParser<dynamic> json({Encoding responseEncoding = utf8})
    => ResponseParser.fromJson((d) => d, responseEncoding: responseEncoding);

  /// Парсит ответ в лист байт
  static ResponseParser<List<int>> bytes() => ResponseParser((response) async => await response.asBroadcastStream().bytesJoin());

  /// Возвращает ответ [HttpClientResponse]
  static ResponseParser<HttpClientResponse> response() => ResponseParser((response) => response);
}

class _CallbackParser<T> implements ResponseParser<T> {
  const _CallbackParser(this.parse);

  final FutureOr<T> Function(HttpClientResponse response) parse;
  
  @override
  FutureOr<T> call(HttpClientResponse response) => parse(response);
}

class _StepParser<T, O> implements ResponseParser<T> {
  const _StepParser(this.firstTranformer, this.finalTransformer);

  final Transformer<HttpClientResponse, FutureOr<O>> firstTranformer;
  final Transformer<O, FutureOr<T>> finalTransformer;

  @override
  FutureOr<T> call(HttpClientResponse response) async => finalTransformer(await firstTranformer(response));
}
