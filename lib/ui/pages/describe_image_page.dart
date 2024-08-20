import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_workshop/data/gemini_service.dart';
import 'package:flutter_ai_workshop/ui/widgets/model_response_widget.dart';

class DescribeImagePage extends StatefulWidget {
  const DescribeImagePage({super.key});

  @override
  State<DescribeImagePage> createState() => _DescribeImagePageState();
}

class _DescribeImagePageState extends State<DescribeImagePage> {
  final List<String> _imagePaths = [
    'assets/img/image-1.jpg',
    'assets/img/image-2.jpeg',
    'assets/img/image-3.jpeg',
    'assets/img/image-4.jpeg',
  ];
  final service = GeminiService();
  final pageController = PageController();

  Future<String?> _modelDescription = Future.value('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gemini will describe your image"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: pageController,
              itemCount: _imagePaths.length,
              onPageChanged: (index) {},
              itemBuilder: (context, index) {
                return Image.asset(
                  _imagePaths[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final imageSelected = _imagePaths[pageController.page?.toInt() ?? 0];
                  final bytes = await rootBundle.load(imageSelected);
                },
                child: const Text("Send to Gemini"),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: FutureBuilder(
              future: _modelDescription,
              builder: (context, snapshot) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleResponseWidget(AsyncSnapshot<String?> snapshot) {
    if (snapshot.hasError) return const Text('Something went wrong');

    if (snapshot.data == null) return const Text('The response will be showed here');

    return ModelResponseWidget(text: snapshot.data!);
  }
}
