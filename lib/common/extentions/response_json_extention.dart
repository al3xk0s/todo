part of 'extentions.dart';

extension ResponseJsonUTF8Extention on HttpClientResponse {
  Future<String> toStringEncoded({Encoding encoding = utf8}) async {
    return await asBroadcastStream().toStringEncoded(encoding: encoding); 
  }

  Future<dynamic> toJson({Encoding responseEncoding = utf8}) async {
    return jsonDecode(await toStringEncoded(encoding: responseEncoding)) as Map<String, dynamic>;
  }
}
