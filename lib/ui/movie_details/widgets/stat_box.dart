import 'package:flutter/material.dart';
import 'package:movie_app/utils/app_style.dart';

class StatBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const StatBox({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(width: 6),
          Text(text, style: AppStyle.roboto24BoldWhite),
        ],
      ),
    );
  }
}
