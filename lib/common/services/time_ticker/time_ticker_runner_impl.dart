part of 'time_ticker.dart';

class TimeTickerRunner implements ITimeTickerRunner {
  _TimeTicker? _timeTicker;

  @override
  bool get isRunned => _timeTicker != null && _timeTicker!.isStarted;

  TimeTickerAsyncHandler? _onEnd;
  TimeTickerAsyncHandler? _onStop;
  TimeTickerAsyncHandler? _onSuccess;

  TimeTickerHandler? _onStart;
  TimeTickerHandler? _onTick;

  TimeTickerErrorHandler? _onError;

  @override
  ITimeTickerRunner onEnd(TimeTickerAsyncHandler handler) {
    _onEnd = handler;
    return this;
  }

  @override
  ITimeTickerRunner onStop(TimeTickerAsyncHandler handler) {
    _onStop = handler;
    return this;
  }

  @override
  ITimeTickerRunner onSuccess(TimeTickerAsyncHandler handler) {
    _onSuccess = handler;
    return this;
  }

  @override
  ITimeTickerRunner onStart(TimeTickerHandler handler) {
    _onStart = handler;
    return this;
  }

  @override
  ITimeTickerRunner onTick(TimeTickerHandler handler) {
    _onTick = handler;
    return this;
  }

  @override
  ITimeTickerRunner onError(TimeTickerErrorHandler handler) {
    _onError = handler;
    return this;
  }

  @override
  Future<void> run(Duration duration, Duration period, {bool preventError = false}) {
    _timeTicker?.stopIfStarted();

    _timeTicker = _TimeTicker(
      duration: duration,
      period: period,
      cancelOnError: preventError,
      onTick: _onTick,
      onStart: _onStart,
      onError: _onError,
    );

    return _timeTicker!
      .start()
      .then((status) async {
        if(status == _TimeTickerEndStatus.stoped) await _onStop?.call(_timeTicker!);
        if(status == _TimeTickerEndStatus.success) await _onSuccess?.call(_timeTicker!);

        return await _onEnd?.call(_timeTicker!);
      });
  }

  @override
  void stop() => _timeTicker?.stopIfStarted();

}