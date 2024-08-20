import 'package:flutter/material.dart';
import 'package:flutter_ai_workshop/data/gemini_service.dart';

class StreamAiPage extends StatefulWidget {
  const StreamAiPage({super.key});

  @override
  State<StreamAiPage> createState() => _StreamAiPageState();
}

class _StreamAiPageState extends State<StreamAiPage> {
  final service = GeminiService();
  final textController = TextEditingController();

  Stream<String?> _modelStream = const Stream.empty();

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
                  _modelStream = service.generateTextStream(textController.text);
                  setState(() {});
                },
                child: const Text("Ask"),
              ),
              const SizedBox(height: 24),
              StreamBuilder<String?>(
                stream: _modelStream,
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

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      height: 400,
      width: MediaQuery.of(context).size.width,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              snapshot.data!,
            ),
          ),
        ),
      ),
    );
  }
}
