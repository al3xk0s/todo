import '../extentions/extentions.dart';
import '../data/serializable/serializable.dart';

abstract class NamedRoute {
  const NamedRoute();

  String get base;
  JsonMap get params;

  String get value;

  String _getParamsString() => params.isEmpty ? '' : '?${params.toUrlEncode()}';

  String _resolveValues(Iterable<String> relativeOthers) {
    if(!relativeOthers.every(_isRelative)) throw Exception('Incorrect relative path');
    return '$base/${relativeOthers.join('/')}';
  }

  bool _isRelative(String rawRoute) => !rawRoute.startsWith('/');

  @override
  String toString() {
    return value;
  }
}

class SimpleNamedRoute extends NamedRoute {
  const SimpleNamedRoute(this.base, { this.params = const {} });

  @override
  final String base;

  @override
  final JsonMap params;

  SimpleNamedRoute resolve(Iterable<String> relativeOthers) 
    => SimpleNamedRoute(_resolveValues(relativeOthers), params: params);

  SimpleNamedRoute resolveNamed(Iterable<NamedRoute> relativeOthers) 
    => resolve(relativeOthers.map((e) => e.value));

  @override
  String get value => base + _getParamsString();

  SimpleNamedRoute withParams(JsonMap params) => SimpleNamedRoute(base, params: params);

  TargetNamedRoute toTargetRoute(String targetName) {
    return TargetNamedRoute(base, targetName: targetName, params: params);
  }
}

class TargetNamedRoute extends NamedRoute {
  TargetNamedRoute(this.base, { required this.targetName, this.params = const {} });

  @override
  final String base;

  @override
  JsonMap params;

  final String targetName;

  @override
  String get value => '$base/:$targetName${_getParamsString()}';

  SimpleNamedRoute toSimpleRoute(String targetValue) {
    return SimpleNamedRoute('$base/$targetValue', params: params);
  }
}