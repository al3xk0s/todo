// ignore_for_file: avoid_print

part of 'error_handler.dart';

class ConsoleErrorHandler implements IErrorHandler {
  const ConsoleErrorHandler();

  @override
  FutureOr<void> handle({required Object error, StackTrace? stackTrace}) {
    print('Error: $error\n');

    if(stackTrace != null) {
      print(stackTrace);
    }
  }
}