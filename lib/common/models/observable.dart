// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';

typedef Disposer = void Function();
typedef Listener<T> = void Function(T value);
typedef AsyncListener<T> = FutureOr<void> Function(T value);

abstract class IDisposable {
  void dispose();
}

abstract class IListenable<T>  {
  Disposer listen(Listener<T> listener);
}

abstract class IAsyncListenable<T> {
  Disposer listen(AsyncListener<T> listener);
}

abstract class IObservable<T> implements IListenable<T>, IDisposable {
  void notify(T value);
}

abstract class IAsyncObservable<T> implements IListenable<T>, IDisposable {
  FutureOr<void> notify(T value);
}

class Observable<T> implements IObservable<T> {
  final List<Listener<T>> _listeners = [];

  @override
  Disposer listen(Listener<T> listener) {
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }

  @override
  void dispose() => _listeners.clear();

  @override
  void notify(T value) {
    for (var listener in _listeners) {
      listener(value);
    }
  }
}

class AsyncObservable<T> implements IAsyncObservable<T> {
  final List<AsyncListener<T>> _listeners = [];

  @override
  Disposer listen(AsyncListener<T> listener) {
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }

  @override
  void dispose() => _listeners.clear();

  @override
  FutureOr<void> notify(T value) async {
    for (var listener in _listeners) {
      await listener(value);
    }
  }
}

abstract class IAddOnlyDisposeWrapper {
  void addDisposer(Disposer disposer);
  void addDisposers(Iterable<Disposer> disposers);

  void addStreamDisposer(StreamSubscription streamSubscription);
  void addStreamDisposers(Iterable<StreamSubscription> streamSubscriptions);
}

abstract class IDisposeWrapper implements IAddOnlyDisposeWrapper, IDisposable {
  void clear();
}

class DisposeWrapper implements IDisposeWrapper {
  final List<Disposer> _subs = [];

  @override
  void addDisposer(Disposer disposer) => _subs.add(disposer);

  @override
  void addDisposers(Iterable<Disposer> disposers) => _subs.addAll(disposers);

  @override
  void addStreamDisposer(StreamSubscription streamSubscription) => addDisposer(streamSubscription.cancel);

  @override
  void addStreamDisposers(Iterable<StreamSubscription> streamSubscriptions) => streamSubscriptions.forEach((sD) => addStreamDisposer(sD));

  @override
  void dispose() {
    for (var disposeSub in _subs) {
      disposeSub();
    }
    clear();
  }

  @override
  void clear() => _subs.clear();
}
