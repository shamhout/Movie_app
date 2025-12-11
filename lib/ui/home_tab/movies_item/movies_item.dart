import 'package:flutter/material.dart';
import 'package:movie_app/api/api_model/movies_response.dart';
import 'package:movie_app/utils/app_color.dart';
import 'package:movie_app/utils/app_route.dart';
import 'package:movie_app/utils/app_style.dart';

class MoviesItem extends StatelessWidget {
  Movies movie;
  MoviesItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.movieDetailsScreen, arguments: movie.id);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: NetworkImage(movie.largeCoverImage!), fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.01),
              width: width * 0.16,
              height: height * 0.05,
              decoration: BoxDecoration(color: AppColor.blackTransparentColor, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${movie.rating}',
                    style: AppStyle.bold16White,
                  ),
                  const Icon(
                    Icons.star,
                    color: AppColor.yellow,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
