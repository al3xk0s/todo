part of '../provider.dart';

// TODO: сделать bool версию, т.е. успех / неудача
class ResponseHandlers<T> {
  /// Callback для парсинга ответа в [T]
  final ResponseParserFunction<T> parser;

  /// Callback для валидации ответа
  /// 
  /// Рекомендуется использовать [BadStatusCodeException] при валидации
  final ResponseValidator? responseValidator;

  /// Callback для валидации ответа, преобразованного в [T]
  final SnapshotValidator<T>? snapshotValidator;

  /// Callback для возврата [T] в случае ошибки
  final ErrorHandler<T>? onError;

  /// Callback для действий в случае успешного запроса
  final ResponseMiddleware? onSuccess;

  /// * [parser]: сallback для парсинга ответа в [T]. Рекомендуется использовать реализацию [ResponseParser]
  /// * [responseValidator]: сallback для валидации ответа
  /// * [snapshotValidator]: сallback для валидации ответа, преобразованного в [T]
  /// * [onError]: сallback для возврата [T] в случае ошибки
  /// * [onSuccess]: сallback для действий в случае успешного запроса
  const ResponseHandlers({
    required this.parser, 
    this.responseValidator,
    this.snapshotValidator,
    this.onError,
    this.onSuccess,
  });
}
