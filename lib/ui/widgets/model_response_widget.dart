import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class ModelResponseWidget extends StatelessWidget {
  final String text;

  const ModelResponseWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: AnimatedTextKit(
        totalRepeatCount: 1,
        animatedTexts: [
          TypewriterAnimatedText(text),
        ],
      ),
    );
  }
}

 
