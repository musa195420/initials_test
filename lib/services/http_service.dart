import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/services/global_service.dart';
import 'package:initial_test/services/pref_service.dart';

class HttpService {
  PrefService get _prefService => locator<PrefService>();
  GlobalService get _globalService => locator<GlobalService>();

  final headers = {
    "Content-Type": "application/json",
    "WLID": "94DE1528-DE42-498A-A07E-4A458E97240E"
  };

  HttpService();

  Future<dynamic> getData(String endpoint) async {
    headers.addAll({
      "Authorization": "Bearer ${await _prefService.getString(PrefKey.token)}"
    });
    final response = await http
        .get(Uri.parse('${await _globalService.getHost()}/$endpoint'),
            headers: headers)
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> postData(String endpoint, Map<String, dynamic>? data,
      {Map<String, String>? customHeaders}) async {
    headers.addAll({
      "Authorization": "Bearer ${await _prefService.getString(PrefKey.token)}"
    });
    final response = await http
        .post(
          Uri.parse('${await _globalService.getHost()}/$endpoint'),
          body: json.encode(data),
          headers: customHeaders ?? headers,
        )
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> patchData(String endpoint, Map<String, dynamic>? data) async {
    headers.addAll({
      "Authorization": "Bearer ${await _prefService.getString(PrefKey.token)}"
    });
    final response = await http
        .patch(
          Uri.parse('${await _globalService.getHost()}/$endpoint'),
          body: json.encode(data),
          headers: headers,
        )
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> postListData(
      String endpoint, List<Map<String, dynamic>>? data) async {
    headers.addAll({
      "Authorization": "Bearer ${await _prefService.getString(PrefKey.token)}"
    });
    final response = await http
        .post(
          Uri.parse('${await _globalService.getHost()}/$endpoint'),
          body: json.encode(data),
          headers: headers,
        )
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> putData(String endpoint, Map<String, dynamic>? data) async {
    headers.addAll({
      "Authorization": "Bearer ${await _prefService.getString(PrefKey.token)}"
    });

    final response = await http
        .put(
          Uri.parse('${await _globalService.getHost()}/$endpoint'),
          body: json.encode(data),
          headers: headers,
        )
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> deleteData(
      String endpoint, Map<String, dynamic>? data) async {
    headers.addAll({
      "Authorization": "Bearer ${await _prefService.getString(PrefKey.token)}"
    });
    final response = await http
        .delete(Uri.parse('${await _globalService.getHost()}/$endpoint'),
            body: json.encode(data), headers: headers)
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<http.StreamedResponse> uploadImage(
      String endpoint, Map<String, String> fields, String filePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${await _globalService.getHost()}/$endpoint'),
    );

    final token = await _prefService.getString(PrefKey.token);
    request.headers.addAll({
      "Authorization": "Bearer $token",
      "WLID": "94DE1528-DE42-498A-A07E-4A458E97240E"
    });

    request.fields.addAll(fields);
    request.files.add(await http.MultipartFile.fromPath('image', filePath));

    return await request.send();
  }

  Future<http.StreamedResponse> uploadMultipleImages(
    String endpoint,
    Map<String, String> fields,
    Map<String, String> filePaths,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${await _globalService.getHost()}/$endpoint'),
    );

    final token = await _prefService.getString(PrefKey.token);
    request.headers.addAll({
      "Authorization": "Bearer $token",
      "WLID": "94DE1528-DE42-498A-A07E-4A458E97240E"
    });

    request.fields.addAll(fields);

    // Attach multiple images with their correct field names
    for (final entry in filePaths.entries) {
      request.files.add(
        await http.MultipartFile.fromPath(entry.key, entry.value),
      );
    }

    return await request.send();
  }
}
