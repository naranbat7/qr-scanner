import 'package:dio/dio.dart';

class ApiRequest {
  static Dio instanceApi([String? baseUrl]) {
    var dio = Dio();
    dio.options
      ..contentType = "application/json"
      ..responseType = ResponseType.json
      ..baseUrl = "https://api.hsforms.com/submissions/v3/integration/submit/22079893/cbf70f81-6ceb-455e-8c18-7fc6c7aa2817"
      ..connectTimeout = 10000 // 30s
      ..receiveTimeout = 10000 // 30s
      ..sendTimeout = 10000
      ..validateStatus = (int? status) {
        return status != null && status > 0;
      };

    return dio;
  }

  static Future<Response> postRequest({required String data}) async {
    final Dio api = ApiRequest.instanceApi();
    return await api.post(
      "",
      data: {
        "fields": [
          {
            "objectTypeId": "0-1",
            "name": "QR",
            "value": data,
          }
        ]
      },
    );
  }
}
