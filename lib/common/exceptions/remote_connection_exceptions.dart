import 'package:todo/common/exceptions/exceptions.dart';
import 'package:todo/common/provider/provider.dart';

abstract class RemoteConnectionExtention implements CommonException {}

class NetworkUnavailableException extends CommonException implements RemoteConnectionExtention {
  @override
  String get message => 'Network connection is unavailable';
}

class RemoteProviderException extends CommonException implements RemoteConnectionExtention {
  const RemoteProviderException(this.message);

  @override
  final String message;
}

class UnsupportedRequestMethodException extends RemoteProviderException {
  UnsupportedRequestMethodException(RequestMethod method) : super('Unsupported request method \'${method.name}\'');
}

class ConnectionTimeoutException extends CommonException implements RemoteConnectionExtention {
  const ConnectionTimeoutException([this.duration]);

  final Duration? duration;

  @override
  String get message => 'Connection timeout refused$_durationMessage';

  String get _durationMessage => duration == null ? '' : ' with timeout: \'$duration\'';
}

abstract class RemoteStatusCodeException extends CommonException implements RemoteConnectionExtention {
  const RemoteStatusCodeException(this.statusCode);

  final int statusCode;
}

class BadStatusCodeException extends RemoteStatusCodeException {
  const BadStatusCodeException(super.statusCode);

  @override
  String get message => 'Bad status code \'$statusCode\' at remote network request';
}

class NotFoundResourceException extends BadStatusCodeException {
  const NotFoundResourceException() : super(404);
}

class RemoteException extends CommonException implements RemoteConnectionExtention {
  const RemoteException(this.message, [this.log]);

  final String? log;

  @override
  final String message;
}

class SessionExpiredException extends CommonException implements RemoteConnectionExtention {
  const SessionExpiredException();

  @override
  String get message => 'Session lifetime expired';
}
