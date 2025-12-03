import 'package:flutter/material.dart';

class ScreenshotsColumn extends StatelessWidget {
  final List<String> images;

  const ScreenshotsColumn({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: images.map((img) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              img,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }
}
