import 'dart:convert';

import 'package:http/http.dart';

class VertexHttpClient extends BaseClient {
  VertexHttpClient(this._projectUrl);

  final String _projectUrl;
  final _client = Client();

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    if (!url
        .toString()
        .contains('https://generativelanguage.googleapis.com/v1/models')) {
      return _client.post(
        url,
        headers: headers,
        body: body,
        encoding: encoding,
      );
    }

    final response = await _client.post(
      Uri.parse(url.toString().replaceAll(
          'https://generativelanguage.googleapis.com/v1/models', _projectUrl)),
      headers: {
        ...Map.fromEntries(
            headers?.entries.where((entry) => entry.key != 'x-goog-api-key') ??
                []),
        'Authorization': 'Bearer ${headers?['x-goog-api-key']}'
      },
      body: body,
      encoding: encoding,
    );

    if (response.statusCode != 200) {
      return response;
    }

    final responseBody = response.body;
    dynamic parsedRespnoseBody;

    try {
      parsedRespnoseBody = json.decode(responseBody);
    } catch (_) {
      return response;
    }

    // We have to rewrite the `citations` to `citationsources` because of
    // incompatiblity between Gemini and Vertex AI. Vertext AI returns
    // `citations` instead of `citationSources`.
    if (parsedRespnoseBody is Map<String, dynamic>) {
      final candidates = parsedRespnoseBody['candidates'];

      if (candidates is List) {
        for (final candidate in candidates) {
          if (candidate is Map<String, dynamic>) {
            final citationMetadata = candidate['citationMetadata'];

            if (citationMetadata is Map<String, dynamic>) {
              citationMetadata['citationSources'] =
                  citationMetadata['citations'];
            }
          }
        }
      }
    }

    return Response(
      json.encode(parsedRespnoseBody),
      response.statusCode,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
      request: response.request,
    );
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) => _client.send(request);
}