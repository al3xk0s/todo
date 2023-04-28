part of '../provider.dart';

/// Задает опции запроса по протоколу http
class RequestOptions {
  /// Способ задания заголовков через [JsonMap]
  final JsonMap? headers;

  /// Способ задания заголовков через callback
  final void Function(HttpHeaders headers)? headersCustomizer;

  /// Куки для запроса
  final List<Cookie> cookies;

  /// Способ кастомизировать реквест
  final RequestMiddleware? requestCustomizer;

  /// Задает допустимый таймаут запроса
  final Duration? timeout;

  /// Вызывается по прошествию таймаута, в случае неудачи
  final FutureOr<HttpClientResponse> Function()? onTimeout;

  /// * [headers]: способ задания заголовков через [JsonMap]
  /// * [headersCustomizer]: способ задания заголовков через callback
  /// * [cookies]: куки для текущего запроса
  /// * [requestCustomizer]: способ кастомизировать реквест через callback
  /// * [timeout]: допустимый таймаут запроса
  /// * [onTimeout]: вызывается по прошествию таймаута, в случае неудачи
  const RequestOptions({
    this.headers, 
    this.requestCustomizer,
    this.cookies = const [],
    this.headersCustomizer,
    this.timeout,
    this.onTimeout,
  });
}
