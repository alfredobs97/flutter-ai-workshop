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
  final geminiService = GeminiService();
  final groqSevice = GroqService();
  final textController = TextEditingController();

  Future<String?> _modelSingleResponse = Future.value(null);

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
                onPressed: () {},
                child: const Text("Ask"),
              ),
              const SizedBox(height: 24),
              FutureBuilder(
                future: _modelSingleResponse,
                builder: (context, snapshot) => const SizedBox.shrink(),
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
}
