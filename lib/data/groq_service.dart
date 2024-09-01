import 'package:flutter/foundation.dart';
import 'package:flutter_ai_workshop/domain/ai_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:groq/groq.dart';

class GroqService extends AiService {
  final Groq _gemma;
  final Groq _llama;

  GroqService()
      : _gemma = Groq(apiKey: dotenv.env['GROQ_API_KEY']!, model: GroqModel.gemma2_9b_it),
        _llama = Groq(apiKey: dotenv.env['GROQ_API_KEY']!, model: GroqModel.llama3_8b_8192);

  @override
  Future<void> init() async {
    _gemma.startChat();
    _llama.startChat();
  }

  @override
  Future<String?> generateContent(String prompt) async {
    try {
      final GroqResponse response = await _gemma.sendMessage(prompt);

      return response.choices.first.message.content;
    } on GroqException catch (error) {
      debugPrint('GroqException: ${error.message}');
      return null;
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      return null;
    }
  }

  @override
  Future<String?> describeImage(Uint8List imageInBytes) {
    throw UnimplementedError();
  }

  @override
  Future<String?> guessLocationOfImage(Uint8List imageInBytes) {
    throw UnimplementedError();
  }

  @override
  Stream<String?> generateTextStream(String prompt) {
    throw UnimplementedError();
  }
}
