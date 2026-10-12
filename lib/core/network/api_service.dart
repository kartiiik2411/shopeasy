import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_constants.dart';
import 'api_exception.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? _sharedClient;

  static final http.Client _sharedClient = http.Client();
  final http.Client _client;

  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
    String? accessToken,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}$path',
    ).replace(queryParameters: queryParameters);
    final response = await _client.get(uri, headers: _headers(accessToken));
    return _decodeResponse(response);
  }

  Future<dynamic> post(
    String path, {
    required Map<String, dynamic> body,
    String? accessToken,
  }) async {
    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}$path'),
      headers: _headers(accessToken)..['Content-Type'] = 'application/json',
      body: jsonEncode(body),
    );
    return _decodeResponse(response);
  }

  Map<String, String> _headers(String? accessToken) => {
    if (accessToken != null && accessToken.isNotEmpty)
      'Authorization': 'Bearer $accessToken',
  };

  dynamic _decodeResponse(http.Response response) {
    dynamic data;
    try {
      data = jsonDecode(response.body);
    } on FormatException {
      throw ApiException(
        'The server returned an invalid response.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = data is Map<String, dynamic>
          ? data['message'] as String? ?? 'Request failed.'
          : 'Request failed.';
      throw ApiException(message, statusCode: response.statusCode);
    }
    return data;
  }
}
