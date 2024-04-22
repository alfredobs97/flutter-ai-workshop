import 'dart:typed_data';

import 'package:flutter_ai_workshop/data/vertex_http_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;
  final GenerativeModel _visionModel;

  GeminiService()
      : _model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: dotenv.env['GEMINI_API_KEY']!,
        ),
        _visionModel = GenerativeModel(
          model: 'gemini-pro-vision',
          apiKey: dotenv.env['GEMINI_API_KEY']!,
        );

  GeminiService.vertexAi({
    required String projectUrl,
  })  : _model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: dotenv.env['VERTEX_API_KEY']!,
          httpClient: VertexHttpClient(projectUrl),
        ),
        _visionModel = GenerativeModel(
          model: 'gemini-pro-vision',
          apiKey: dotenv.env['VERTEX_API_KEY']!,
          httpClient: VertexHttpClient(projectUrl),
        );

  Future<String?> generateText(String prompt) async {}

  Future<List<String?>> generateMultiplesReponses(String prompt) async {
    return [];
  }

  Future<String> describeImage(Uint8List imageInBytes) async {
    return 'No description found for this image, try again!';
  }

  Future<String?> guessLocationOfImage(Uint8List imageInBytes) async {
    return 'No location found!';
  }

  Stream<String?> generateTextStream(String prompt) {
    return const Stream.empty();
  }
}
