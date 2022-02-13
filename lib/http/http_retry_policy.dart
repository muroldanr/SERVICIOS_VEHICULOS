import 'dart:convert';
import 'package:best_flutter_ui_templates/src/providers/session_provider.dart';
import 'package:http_interceptor/http_interceptor.dart';
//import 'http_routes.dart';

class ExpiredTokenRetryPolicy extends RetryPolicy {
  final SessionProvider _prov = new SessionProvider();

  final _client = HttpClientWithInterceptor.build(interceptors: [
    // nterceptor(),
  ]);

  // ignore: avoid_init_to_null
  Future<dynamic>? cachRequest = null;

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    final Uri loginUri = Uri.parse(_prov.apiUri! + '/Login');
    if (response.statusCode == 401) {
      if (cachRequest == null) {
        Map body = {
          'AccessToken': _prov.session.access,
          'RefreshToken': _prov.session.refresh
        };
        cachRequest = _client.post(
          loginUri,
          body: json.encode(body),
          headers: {"Content-Type": "application/json"},
        );
      }
      var res = await cachRequest;
      cachRequest = null;
      if (res.statusCode == 200) {
        var decoded = json.decode(res.body);
        _prov.session.access = decoded["access_token"];
        _prov.session.refresh = decoded["refresh_token"];
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
