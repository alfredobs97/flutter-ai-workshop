import 'dart:typed_data';

abstract class AiService {
  Future<void> init();

  Future<String?> generateContent(String prompt);

  Future<String?> describeImage(Uint8List imageInBytes);

  Future<String?> guessLocationOfImage(Uint8List imageInBytes);

  Stream<String?> generateTextStream(String prompt);
}
