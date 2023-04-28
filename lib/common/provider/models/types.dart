part of '../provider.dart';

typedef ResponseValidator = void Function(RequestMethod requestMethod, HttpClientResponse res);
typedef SnapshotValidator<T> = void Function(RequestMethod requestMethod, T snap);
typedef ErrorHandler<T> = T Function(Object error, StackTrace stackTrace);