part of 'get_state.dart';

abstract class IGetStateController<S> implements GetxController {
  Rx<S> get state;
  void emitState(S newState);
}

class BaseGetStateController<S> extends GetxController implements IGetStateController<S> {
  BaseGetStateController(S initialState) : state = initialState.obs;

  @override
  final Rx<S> state;

  @override
  void emitState(S newState) {
    state.value = newState;
  }
}

// TODO: стандартизировать / обобщить стейты по такой же схеме
abstract class GetState {
  const GetState();

  static const GetState initial = _GetStateInitial();
  static const GetState process = _GetStateProcess();
  static const GetState success = GetStateSuccess.empty();
  static const GetState failed = GetStateFailed.empty();

  @override
  bool operator==(covariant GetState other) => super == other || runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

class _GetStateInitial implements GetState {
  const _GetStateInitial();
}

class _GetStateProcess implements GetState {
  const _GetStateProcess();
}

class _GetStateEmptyble implements GetState {
  const _GetStateEmptyble.empty() : isEmpty = true;
  const _GetStateEmptyble() : isEmpty = false;

  final bool isEmpty;
}

class GetStateSuccess<T> extends _GetStateEmptyble {
  const GetStateSuccess(T data) : _data = data;
  const GetStateSuccess.empty() : _data = null, super.empty();

  T get data => _data!;
  final T? _data;
}

class GetStateFailed extends _GetStateEmptyble {
  const GetStateFailed(this.exception, this.stackTrace);
  const GetStateFailed.empty() : exception = '', stackTrace = StackTrace.empty, super.empty();

  final Object exception;
  final StackTrace stackTrace;
}