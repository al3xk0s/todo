part of '../provider.dart';

abstract class _IMiddlewareStorage<T> {
  void add(Middleware<T> middleware);
  FutureOr<void> execute(T target);
}

class _MiddlewareStorage<T> implements _IMiddlewareStorage<T> {
  _MiddlewareStorage(List<Middleware<T>>? middlewares) {
    _middlewares = middlewares?.toList() ?? [];
  }

  late final List<Middleware<T>> _middlewares;

  @override
  void add(Middleware<T> middleware) {
    _middlewares.add(middleware);
  }

  @override
  Future<void> execute(T target) async {
    for (var middleware in _middlewares) {
      await middleware(target);
    }
  }
}