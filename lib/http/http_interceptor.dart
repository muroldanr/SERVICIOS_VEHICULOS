import 'package:best_flutter_ui_templates/src/providers/session_provider.dart';
import 'package:http_interceptor/http_interceptor.dart';

class Interceptor implements InterceptorContract {
  SessionProvider _prov = new SessionProvider();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      if (await _prov.validaRefresh()) {
        //AGREGAR ACCESS TOKEN EN CADA PETICION
        String? accessToken = _prov.session.access;
        data!.headers["Authorization"] = "Bearer $accessToken";
        return data;
      } else {
        return data;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}
