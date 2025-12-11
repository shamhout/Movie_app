import 'package:flutter/material.dart';
import 'package:movie_app/utils/app_style.dart';

class GenresList extends StatelessWidget {
  final List<String> genres;

  const GenresList({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    double itemWidth = (MediaQuery.of(context).size.width - 60) / 3;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: genres
          .map(
            (g) => Container(
              width: itemWidth,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF303030),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                g,
                style: AppStyle.roboto16RegularWhite,
              ),
            ),
          )
          .toList(),
    );
  }
}
