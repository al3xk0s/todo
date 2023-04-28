part of '../provider.dart';

abstract class RequestBody {
  void apply(HttpClientRequest request);

  factory RequestBody.value(String value) => _StringRequestBody(value);
  factory RequestBody.bytes(List<int> bodyBytes) => _BytesRequestBody(bodyBytes);
  factory RequestBody.encoded(String value, {Encoding encoding = utf8}) => _EncodedRequestBody(value: value, encoding: encoding);
  factory RequestBody.json(dynamic jsonData) => _JsonRequestBody(jsonData);
}

class _StringRequestBody implements RequestBody {
  const _StringRequestBody(this.value);
  final String value;

  @override
  void apply(HttpClientRequest request) {
    request.write(value);
  }
}

class _BytesRequestBody implements RequestBody {
  const _BytesRequestBody(this.bodyBytes);
  final List<int> bodyBytes;

  @override
  void apply(HttpClientRequest request) {    
    request.add(bodyBytes);
    request.headers.contentLength += bodyBytes.length;
  }
}

class _EncodedRequestBody extends _BytesRequestBody {
  _EncodedRequestBody({
    required String value, 
    required Encoding encoding,
  }) : super(encoding.encode(value));
}

class _JsonRequestBody extends _EncodedRequestBody {
  _JsonRequestBody(dynamic jsonData, {Encoding encoding = utf8}) : super(value: json.encode(jsonData), encoding: encoding);
}