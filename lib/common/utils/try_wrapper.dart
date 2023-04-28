import 'dart:async';

import '../services/error_handler/error_handler.dart';

abstract class ITryWrapper {
  Future<T?> tryGetAsyncValue<T>(Future<T> Function() executor);
  T? tryGetValue<T>(T Function() executor);

  Future<bool> tryExecuteAsync(Future<void> Function() executor);
  bool tryExecute(void Function() executor);
}

class TryWrapperHandle implements ITryWrapper {
  const TryWrapperHandle({required this.errorHandler});

  final IErrorHandler errorHandler;

  @override
  bool tryExecute(void Function() executor) {
    try {
      executor();
      return true;
    } catch (e, s) {
      errorHandler.handle(error: e, stackTrace: s);
      return false;
    }
  }

  @override
  Future<bool> tryExecuteAsync(Future<void> Function() executor) async {
    try {
      await executor();
      return true;
    } catch(e, s) {
      errorHandler.handle(error: e, stackTrace: s);
      return false;
    }
  }

  @override
  Future<T?> tryGetAsyncValue<T>(Future<T> Function() executor) async {
    try {
      return await executor();
    } catch (e, s) {
      errorHandler.handle(error: e, stackTrace: s);
      return null;
    }
  }

  @override
  T? tryGetValue<T>(T Function() executor) {
    try {
      return executor();
    } catch (e, s) {
      errorHandler.handle(error: e, stackTrace: s);
      return null;
    }
  }

}
