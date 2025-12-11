import 'package:flutter/material.dart';
import 'package:movie_app/api/api_model/movies_response.dart';
import 'package:movie_app/utils/app_color.dart';
import 'package:movie_app/utils/app_route.dart';
import 'package:movie_app/utils/app_style.dart';

class SeeMoreScreen extends StatelessWidget {
  final String title;
  final List<Movies> movies;

  const SeeMoreScreen({
    super.key,
    required this.title,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: AppStyle.bold20White),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: movies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            var movie = movies[index];

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoute.movieDetailsScreen,
                  arguments: movie.id,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: NetworkImage(movie.largeCoverImage ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: height * 0.01,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColor.blackTransparentColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${movie.rating}',
                            style: AppStyle.bold16White,
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.star, color: AppColor.yellow, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
