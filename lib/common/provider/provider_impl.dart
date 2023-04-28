part of 'provider.dart';

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
    ..badCertificateCallback = ((cert, host, port) => true);
  }
}

class Provider implements IProvider {
  Provider({
    List<RequestMiddleware>? requestMiddlewares,
    List<ResponseMiddleware>? responseMiddlewares,
    bool ignoreSsl = false,
  }) {
    _requestMiddlewares = _MiddlewareStorage(requestMiddlewares);
    _responseMiddlewares = _MiddlewareStorage(responseMiddlewares);
    if(ignoreSsl) HttpOverrides.global = DevHttpOverrides();
    _client = HttpClient();
  }

  late final HttpClient _client;
  late final _IMiddlewareStorage<HttpClientRequest> _requestMiddlewares;
  late final _IMiddlewareStorage<HttpClientResponse> _responseMiddlewares;

  late final _methodBuilderMap = <RequestMethod, Future<HttpClientRequest> Function(Uri)>{
    RequestMethod.get: _client.getUrl,
    RequestMethod.post: _client.postUrl,
    RequestMethod.put: _client.putUrl,
    RequestMethod.delete: _client.deleteUrl,
  };

  Future<HttpClientRequest> Function(Uri) _getBuilderAtMethod(RequestMethod method) {
    final builder = _methodBuilderMap[method];
    if(builder == null) throw UnsupportedRequestMethodException(method);
    return builder;
  }

  @override
  Future<T> fetch<T>(
    Uri uri, {
    required RequestMethod method,
    required ResponseHandlers<T> handlers,
    RequestBody? body,
    RequestOptions options = const RequestOptions(),
  }) async {
    return await _getResultWithExceptionHandle(
      uri: uri,
      method: method,
      options: options,
      body: body,
      handlers: handlers
    );
  }

  Future<void> download(Uri uri, String path) async {
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();
    final byteLists = await response.asBroadcastStream().toList();
    final bytes = <int>[];

    for (final ls in byteLists) {
      for (var byte in ls) {
        bytes.add(byte);
      }
    }

    await File(path).writeAsBytes(bytes);
  }

  Future<T> _getResultWithExceptionHandle<T>({
    required Uri uri,
    required RequestMethod method,
    required RequestOptions options,
    RequestBody? body,
    required ResponseHandlers<T> handlers,
  }) async {

    try {
      return await _withExceptionMapping(() => _getResult(uri, method, options, body, handlers));
    } catch(e, s) {
      if(handlers.onError == null) rethrow;
      return handlers.onError!(e, s);
    }
  }

  Future<T> _getResult<T>(
    Uri uri,
    RequestMethod method,
    RequestOptions options,
    RequestBody? body,
    ResponseHandlers<T> handlers,
  ) async {
    final req = await _getBuilderAtMethod(method)(uri);
    _prepareRequest(req, options);
    if(body != null) body.apply(req);
    
    final responseFuture = req.close();
    
    if(options.timeout != null) {
      responseFuture.timeout(
        options.timeout!,
        onTimeout: options.onTimeout ?? () => _onTimeout(options.timeout!),
      );
    }
    
    final response = await responseFuture;
    return await _getSnapshot(method, response, handlers);
  }

  void _prepareRequest(
    HttpClientRequest req, 
    RequestOptions options
  ) {
    _requestMiddlewares.execute(req);
    _addHeaders(req, options.headers);
    _addCookies(req, options.cookies);    
    options.headersCustomizer?.call(req.headers);
    options.requestCustomizer?.call(req);
  }

  Future<T> _getSnapshot<T>(
    RequestMethod requestMethod,
    HttpClientResponse res, 
    ResponseHandlers<T> handlers
  ) async {

    handlers.responseValidator?.call(requestMethod, res);

    final snapshot = await handlers.parser(res);
    handlers.snapshotValidator?.call(requestMethod, snapshot);

    await _responseMiddlewares.execute(res);
    
    handlers.onSuccess?.call(res);

    return snapshot;
  }

  void _addHeaders(HttpClientRequest request, Map<String, dynamic>? headers) {
    headers?.forEach((name, value) {
      request.headers.add(name, value);
    });
  }

  void _addCookies(HttpClientRequest request, List<Cookie> cookies) {
    request.cookies.addAll(cookies);
  }
  
  @override
  void useRequestMiddleware(RequestMiddleware middleware) => _requestMiddlewares.add(middleware);

  @override
  void useResponseMiddleware(ResponseMiddleware middleware) => _responseMiddlewares.add(middleware);

  HttpClientResponse _onTimeout(Duration timeout) => throw ConnectionTimeoutException(timeout);

  Future<T> _withExceptionMapping<T>(Future<T> Function() executor) async {
    try {
      return await executor();
    } on HttpException catch(e) {
      throw RemoteProviderException(e.toString());
    } on SocketException {
      throw NetworkUnavailableException();
    } catch (_) {
      rethrow;
    }
  }
}