part of '../provider.dart';

typedef Middleware<T> = FutureOr<void> Function(T target);

typedef RequestMiddleware = Middleware<HttpClientRequest>;
typedef ResponseMiddleware = Middleware<HttpClientResponse>;