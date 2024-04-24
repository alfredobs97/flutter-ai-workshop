import 'dart:typed_data';

import 'package:flutter_ai_workshop/data/vertex_http_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';
import 'package:rxdart/rxdart.dart';

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

  Future<String?> generateText(String prompt) async {
    final content = Content.text(prompt);
    final response = await _model.generateContent([content]);

    // We can access to the generated text from the model
    return response.text;
  }

  Future<List<String?>> generateMultiplesReponses(String prompt) async {
    final content = Content.text(prompt);
    final generationConfig = GenerationConfig(
      candidateCount: 3,
      maxOutputTokens: 2048,
      temperature: 0.7,
    );
    final response = await _model.generateContent(
      [content],
      generationConfig: generationConfig,
    );

    return response.candidates
        .where((candidate) => candidate.finishReason == null)
        .map((candidate) => (candidate.content.parts[0] as TextPart).text)
        .toList();
  }

  Future<String> describeImage(Uint8List imageInBytes) async {
    final mimeType = lookupMimeType('image', headerBytes: imageInBytes) ?? 'image/*';

    final imageContent = DataPart(mimeType, imageInBytes);
    final describeImagePrompt = TextPart('Describe this image:');

    final prompt = Content.multi([describeImagePrompt, imageContent]);

    final response = await _visionModel.generateContent([prompt]);

    return response.text ?? 'No description found for this image, try again!';
  }

  Future<String?> guessLocationOfImage(Uint8List imageInBytes) async {
    final mimeType = lookupMimeType('image', headerBytes: imageInBytes) ?? 'image/*';
    final imageContent = DataPart(mimeType, imageInBytes);

    final describeImagePrompt = TextPart(
        'Guess the location of this image, you must provide a short description of the location and GPS coordinates in the format "latitude,longitude":');

    final prompt = Content.multi([describeImagePrompt, imageContent]);

    final response = await _visionModel.generateContent([prompt]);

    return response.text ?? 'No location found!';
  }

  Stream<String?> generateTextStream(String prompt) {
    final content = Content.text(prompt);

    return _model
        .generateContentStream([content])
        .where(
          (event) => event.text != null,
        )
        .transform(
          ScanStreamTransformer((acc, curr, _) => acc! + curr.text!, ''),
        );
  }
}



///  Future<String> describeImage(Uint8List imageInBytes) async {
///    final mimeType = lookupMimeType('image', headerBytes: imageInBytes) ?? 'image/*';
///
///    final imageContent = DataPart(mimeType, imageInBytes);
///    final describeImagePrompt = TextPart('Describe this image:');
///
///    final prompt = Content.multi([describeImagePrompt, imageContent]);
///
///    final response = await visionModel.generateContent([prompt]);
///
///    return response.text ?? 'No description found for this image, try again!';
///  }
///
///    Future<String> describeImage(Uint8List imageInBytes) async {
///    final mimeType = lookupMimeType('image', headerBytes: imageInBytes) ?? 'image/*';
///
///    final imageContent = DataPart(mimeType, imageInBytes);
///    final describeImagePrompt = TextPart('Describe this image:');
///
///    final prompt = Content.multi([describeImagePrompt, imageContent]);
///
///    final response = await visionModel.generateContent([prompt]);
///
///    return response.text ?? 'No description found for this image, try again!';
///  } 
///
