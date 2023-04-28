part of 'time_ticker.dart';

class _TimeTicker implements ITimeTicker {
  @override
  final Duration duration;

  @override
  final Duration period;
  
  _TimeTicker({
    required this.duration,
    required this.period,
    required this.cancelOnError,
    TimeTickerHandler? onTick,
    TimeTickerHandler? onStart,
    TimeTickerErrorHandler? onError,
  }) :  _onTick = onTick,
        _onStart = onStart,
        _onError = onError;

  final bool cancelOnError;
  static const _initialPastTime = Duration.zero;

  @override
  bool get timeIsOver => lastTime.inSeconds <= 0;

  @override
  Duration get pastTime => _pastTime;
  Duration _pastTime = _initialPastTime;

  @override
  Duration get lastTime => duration - _pastTime;

  @override
  bool get isStarted => _sub != null;

  Completer<_TimeTickerEndStatus>? _completer;
  StreamSubscription<void>? _sub;

  Future<_TimeTickerEndStatus> start() {
    if(isStarted) throw Exception('Ticker already started');

    _completer = Completer();
    _onStart?.call(this);

    _sub = Stream<void>.periodic(period).listen(
      _onStreamTick,
      onError: _onStreamError,
      cancelOnError: cancelOnError,
    );
  
    return _completer!.future;
  }

  void _onStreamTick(void _) {
    _pastTime += period;      
    if(timeIsOver) return _endTimer(_TimeTickerEndStatus.success);
    return _onTick?.call(this);
  }

  void _onStreamError(Object error, StackTrace stackTrace) {
    if(!cancelOnError) return _onError?.call(this, error, stackTrace);

    if(_onError != null) {
      _onError?.call(this, error, stackTrace);
      return _endTimer(_TimeTickerEndStatus.stoped);
    }
    final c = _completer!;
    _resetValues();
    return c.completeError(error, stackTrace);
  }

  void _resetValues() {
    _pastTime = _initialPastTime;
    _completer = null;
    _sub = null;
  }

  void _endTimer(_TimeTickerEndStatus endStatus) async {
    _sub?.cancel();
    _completer?.complete(endStatus);
    _resetValues();
  }

  bool stopIfStarted() {
    if(!isStarted) return false;
    _endTimer(_TimeTickerEndStatus.stoped);
    return true;
  }

  final TimeTickerHandler? _onTick;
  final TimeTickerHandler? _onStart;
  final TimeTickerErrorHandler? _onError;
}
