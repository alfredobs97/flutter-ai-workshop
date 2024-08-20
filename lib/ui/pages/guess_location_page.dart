// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_workshop/data/gemini_service.dart';
import 'package:flutter_ai_workshop/ui/widgets/model_response_widget.dart';
import 'package:image_picker/image_picker.dart';

class GuessLocationPage extends StatefulWidget {
  const GuessLocationPage({super.key});

  @override
  State<GuessLocationPage> createState() => _GuessLocationPageState();
}

class _GuessLocationPageState extends State<GuessLocationPage> {
  final picker = ImagePicker();
  final geminiService = GeminiService();

  Uint8List? imageInBytes;
  Future<String?>? modelDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess the location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Upload your image'),
            imageInBytes != null ? Image.memory(imageInBytes!) : const SizedBox(),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Upload'),
            ),
            FutureBuilder(
              future: modelDescription,
              builder: (context, snapshot) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: switch (snapshot.connectionState) {
                    ConnectionState.waiting => const CircularProgressIndicator.adaptive(),
                    _ => _buildSingleResponseWidget(snapshot),
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
      return;
    }

    imageInBytes = await image.readAsBytes();

    setState(() {});
  }

  Widget _buildSingleResponseWidget(AsyncSnapshot<String?> snapshot) {
    if (snapshot.hasError) return const Text('Something went wrong');

    if (snapshot.data == null) return const Text('The response will be showed here');

    return ModelResponseWidget(text: snapshot.data!);
  }
}
