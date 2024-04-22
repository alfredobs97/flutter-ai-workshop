import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:groq/groq.dart';

class GroqService {
  final gemma = Groq(model: GroqModel.gemma, apiKey: dotenv.env['GROQ_API_KEY']!);
  final llama = Groq(model: GroqModel.meta, apiKey: dotenv.env['GROQ_API_KEY']!);

  void init() {
    gemma.startChat();
  }

  Future<String?> generateContent(String prompt) async {}
}
 