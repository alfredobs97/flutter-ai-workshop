import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_workshop/data/gemini_service.dart';
import 'package:flutter_ai_workshop/data/groq_service.dart';
import 'package:flutter_ai_workshop/ui/widgets/model_response_widget.dart';

class AskAiPage extends StatefulWidget {
  const AskAiPage({super.key});

  @override
  State<AskAiPage> createState() => _AskAiPageState();
}

class _AskAiPageState extends State<AskAiPage> {
  final geminiService = GeminiService.vertexAi(
    projectUrl: '',
  );
  final textController = TextEditingController();

  Future<String?> _modelSingleResponse = Future.value(null);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "In the following text box, you can ask to Gemini whatever you want",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Text field for user input
              TextField(
                maxLines: 4,
                controller: textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ask your question here...',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  _modelSingleResponse = geminiService.generateText(textController.text);
                  setState(() {});
                },
                child: const Text("Ask"),
              ),
              const SizedBox(height: 24),
              FutureBuilder(
                future: _modelSingleResponse,
                builder: (context, snapshot) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: switch (snapshot.connectionState) {
                      ConnectionState.waiting => const CircularProgressIndicator.adaptive(),
                      _ => _buildSingleResponseWidget(snapshot),
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleResponseWidget(AsyncSnapshot<String?> snapshot) {
    if (snapshot.hasError) return const Text('Something went wrong');

    if (snapshot.data == null) return const Text('The response will be showed here');

    return ModelResponseWidget(text: snapshot.data!);
  }

  Widget _buildMultipleResponseWidget(AsyncSnapshot<List<String?>> snapshot) {
    if (snapshot.hasError) return const Text('Something went wrong');

    if (snapshot.data == null) return const Text('The response will be showed here');

    return Column(
      children: snapshot.data!
          .where((element) => element != null)
          .map((element) => ExpansionTile(
                title: const Text('Model response'),
                children: [Text(element!)],
              ))
          .toList(),
    );
  }
}
