part of 'time_ticker.dart';

typedef TimeTickerHandler = void Function(ITimeTicker ticker);
typedef TimeTickerAsyncHandler = FutureOr<void> Function(ITimeTicker ticker);
typedef TimeTickerErrorHandler = void Function(ITimeTicker ticker, Object object, StackTrace stackTrace);

enum _TimeTickerEndStatus {
  success,
  stoped,
}

abstract class ITimeTickerRunner {
  bool get isRunned;

  Future<void> run(Duration duration, Duration period, { bool preventError = false });

  void stop();

  ITimeTickerRunner onTick(TimeTickerHandler handler);
  ITimeTickerRunner onStart(TimeTickerHandler handler);

  ITimeTickerRunner onStop(TimeTickerAsyncHandler listener);
  ITimeTickerRunner onSuccess(TimeTickerAsyncHandler listener);
  ITimeTickerRunner onEnd(TimeTickerAsyncHandler listener);

  ITimeTickerRunner onError(TimeTickerErrorHandler listener);
}

abstract class ITimeTicker {
  Duration get duration;
  Duration get period;

  bool get isStarted;
  bool get timeIsOver;

  Duration get pastTime;
  Duration get lastTime;
}
