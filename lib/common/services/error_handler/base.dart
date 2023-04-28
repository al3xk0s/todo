part of 'error_handler.dart';

abstract class IErrorHandler<E extends Object> {
  FutureOr<void> handle({
    required E error,
    StackTrace? stackTrace,
  });
}