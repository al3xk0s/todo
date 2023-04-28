part of 'provider.dart';

enum RequestMethod {
  get,
  post,
  delete,
  put,
}

/// Абстракция над удаленными `CRUD` операциями
/// 
/// `Исключения: `
/// 
/// * [NetworkUnavailableException]
/// * [RemoteProviderException]
/// * [ConnectionTimeoutException]
/// * [UnsupportedRequestMethodException]
abstract class IProvider {
  /// Добавляет функцию, которая будет вызвана каждый раз после создания реквеста
  void useRequestMiddleware(RequestMiddleware middleware);

  /// Добавляет функцию, которая будет вызвана при каждом успешном ответе сервера, но до обработчика `onSuccess` из [ResponseHandlers]
  void useResponseMiddleware(ResponseMiddleware middleware);

  Future<T> fetch<T>(
    Uri uri, {
    required RequestMethod method,
    required ResponseHandlers<T> handlers,
    RequestBody? body,
    RequestOptions options = const RequestOptions(),
  });
}
