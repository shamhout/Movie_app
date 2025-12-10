import 'package:flutter/material.dart';
import 'package:movie_app/utils/app_color.dart';
import 'package:movie_app/utils/app_style.dart';

class SimilarItem extends StatelessWidget {
  final String imagePath;
  final String rating;

  const SimilarItem({
    super.key,
    required this.imagePath,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imagePath,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(rating, style: AppStyle.roboto16RegularWhite),
                const SizedBox(width: 4),
                const Icon(Icons.star, color: AppColor.yellow, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
