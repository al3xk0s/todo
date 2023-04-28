part of 'exceptions.dart';

abstract class CommonException implements Exception {
  const CommonException();

  dynamic get message;
  
  @override
  String toString() => message.toString();
}
