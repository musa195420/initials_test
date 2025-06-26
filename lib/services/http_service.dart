import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  final headers = {
    "Content-Type": "application/json",
    "token": "4c161cc78151405d23e02d352f41b10bdf3df790"
  };

  String endpoint = 'https://api.waqi.info/feed';
  HttpService();

  Future<dynamic> getData(String endpoint) async {
    final response = await http
        .get(Uri.parse('/$endpoint'), headers: headers)
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> postData(String endpoint, Map<String, dynamic>? data,
      {Map<String, String>? customHeaders}) async {
    final response = await http
        .post(
          Uri.parse('/$endpoint'),
          body: json.encode(data),
          headers: customHeaders ?? headers,
        )
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> patchData(String endpoint, Map<String, dynamic>? data) async {
    final response = await http
        .patch(
          Uri.parse('/$endpoint'),
          body: json.encode(data),
          headers: headers,
        )
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> postListData(
      String endpoint, List<Map<String, dynamic>>? data) async {
    final response = await http
        .post(
          Uri.parse('/$endpoint'),
          body: json.encode(data),
          headers: headers,
        )
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> putData(String endpoint, Map<String, dynamic>? data) async {
    final response = await http
        .put(
          Uri.parse('/$endpoint'),
          body: json.encode(data),
          headers: headers,
        )
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> deleteData(
      String endpoint, Map<String, dynamic>? data) async {
    final response = await http
        .delete(Uri.parse('/$endpoint'),
            body: json.encode(data), headers: headers)
        .timeout(const Duration(minutes: 1));

    return response;
  }
}
