import 'dart:typed_data';

import 'package:flutter_ai_workshop/domain/ai_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';
import 'package:rxdart/rxdart.dart';

class GeminiService extends AiService {
  final GenerativeModel _model;

  GeminiService()
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: dotenv.env['GEMINI_API_KEY']!,
        );

  @override
  Future<void> init() async {}

  @override
  Future<String?> generateContent(String prompt) async {
    final content = Content.text(prompt);

    return (await _model.generateContent([content])).text;
  }

  @override
  Future<String?> describeImage(Uint8List imageInBytes) async {
    final mimeType = lookupMimeType('image', headerBytes: imageInBytes) ?? 'image/*';

    final imageContent = DataPart(mimeType, imageInBytes);
    final describeImagePrompt = TextPart('Describe this image:');

    final prompt = Content.multi([describeImagePrompt, imageContent]);

    final response = await _model.generateContent([prompt]);

    return response.text ?? 'No description found for this image, try again!';
  }

  @override
  Future<String?> guessLocationOfImage(Uint8List imageInBytes) async {
    final mimeType = lookupMimeType('image', headerBytes: imageInBytes) ?? 'image/*';

    final imageContent = DataPart(mimeType, imageInBytes);

    final guessLocationPrompt = TextPart(
      '''Given a visual representation, please use analytical skills as a keen researcher would. 
        Observe distinctive natural elements such as flora and fauna present in the scene along with any visible landforms 
        or weather patterns to make your best educated guess about where this specific location could be situated on Earth.''',
    );

    final prompt = Content.multi([guessLocationPrompt, imageContent]);

    final response = await _model.generateContent([prompt]);

    return response.text ?? 'No description found for this image, try again!';
  }

  @override
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
