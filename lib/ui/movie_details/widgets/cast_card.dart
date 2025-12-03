import 'package:flutter/material.dart';
import 'package:movie_app/utils/app_style.dart';

class CastCard extends StatelessWidget {
  final String image;
  final String name;
  final String character;

  const CastCard({
    super.key,
    required this.image,
    required this.name,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              image,
              width: 55,
              height: 55,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name : $name", style: AppStyle.roboto20RegularWhite),
                const SizedBox(height: 4),
                Text(
                  "Character : $character",
                  style: AppStyle.roboto20RegularWhite,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
