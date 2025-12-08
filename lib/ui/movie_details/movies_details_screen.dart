import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/api/api_manger.dart';
import 'package:movie_app/models/Api_movie_deatils.dart';
import 'package:movie_app/ui/movie_details/widgets/cast_card.dart';
import 'package:movie_app/ui/movie_details/widgets/genres_list.dart';
import 'package:movie_app/ui/movie_details/widgets/screenshots_list.dart';
import 'package:movie_app/ui/movie_details/widgets/similar_item.dart';
import 'package:movie_app/ui/movie_details/widgets/stat_box.dart';
import 'package:movie_app/utils/app_color.dart';
import 'package:movie_app/utils/app_route.dart';
import 'package:movie_app/utils/app_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: FutureBuilder<MovieModel>(
        future: ApiManager.getMovieDetails(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColor.yellow,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          } else {
            final movie = snapshot.data!;
            return MovieDetailsContent(movie: movie);
          }
        },
      ),
    );
  }
}

class MovieDetailsContent extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailsContent({super.key, required this.movie});

  @override
  State<MovieDetailsContent> createState() => _MovieDetailsContentState();
}

class _MovieDetailsContentState extends State<MovieDetailsContent> {
  bool isSaved = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: widget.movie.largeCoverImage ?? "",
                width: double.infinity,
                height: height * 0.8,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(
                    child: CircularProgressIndicator(
                  color: AppColor.yellow,
                )),
                errorWidget: (_, __, ___) => const Icon(Icons.error),
              ),
              Container(
                  height: height * 0.8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  )),
              Positioned(
                top: 40,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                top: 35,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSaved = !isSaved;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: height * 0.33,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColor.yellow,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColor.whiteColor,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          color: AppColor.yellow,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: AppColor.whiteColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: height * 0.7,
                  left: 0,
                  right: 0,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text(widget.movie.title ?? '', style: AppStyle.roboto24BoldWhite),
                    SizedBox(height: height * 0.01),
                    Text('${widget.movie.year ?? ""}', style: AppStyle.roboto20BoldGray),
                    SizedBox(height: height * 0.015),
                  ]))
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: height * 0.018),
                    ),
                    child: Text(appLocalizations.watch, style: AppStyle.roboto20BoldWhite),
                  ),
                ),
                SizedBox(height: height * 0.018),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.005),
                        child: StatBox(
                          icon: Icons.favorite,
                          text: widget.movie.likeCount?.toString() ?? "0",
                          color: AppColor.yellow,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.005),
                        child: StatBox(
                          icon: Icons.access_time_filled,
                          text: '${widget.movie.runtime ?? 0}',
                          color: AppColor.yellow,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.005),
                        child: StatBox(
                          icon: Icons.star,
                          text: widget.movie.rating?.toString() ?? "-",
                          color: AppColor.yellow,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.025),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(appLocalizations.screenShots, style: AppStyle.roboto24BoldWhite),
                ),
                SizedBox(height: height * 0.01),
                ScreenshotsColumn(images: widget.movie.mediumScreenshots ?? []),
                SizedBox(height: height * 0.025),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(appLocalizations.similar, style: AppStyle.roboto24BoldWhite),
                ),
                SizedBox(height: height * 0.015),
                FutureBuilder(
                  future: ApiManager.getMovieSuggestions(widget.movie.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Text("Error loading suggestions");
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("No similar movies found");
                    } else {
                      var suggestions = snapshot.data!;

                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet ? 3 : 2,
                          crossAxisSpacing: width * 0.03,
                          mainAxisSpacing: height * 0.015,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: suggestions.length,
                        itemBuilder: (context, index) {
                          var movie = suggestions[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoute.movieDetailsScreen,
                                arguments: movie.id,
                              );
                            },
                            child: SimilarItem(
                              imagePath: movie.image,
                              rating: movie.rating.toString(),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                SizedBox(height: height * 0.025),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(appLocalizations.summary, style: AppStyle.roboto24BoldWhite),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  widget.movie.descriptionFull ?? "",
                  style: AppStyle.roboto16RegularWhite,
                ),
                SizedBox(height: height * 0.025),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(appLocalizations.cast, style: AppStyle.roboto24BoldWhite),
                ),
                SizedBox(height: height * 0.01),
                Column(
                  children: widget.movie.cast?.map((actor) {
                        return CastCard(
                          image: actor.urlSmallImage ?? "",
                          name: actor.name ?? "",
                          character: actor.characterName ?? "",
                        );
                      }).toList() ??
                      [],
                ),
                SizedBox(height: height * 0.025),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(appLocalizations.genres, style: AppStyle.roboto24BoldWhite),
                ),
                SizedBox(height: height * 0.012),
                GenresList(genres: widget.movie.genres ?? []),
                SizedBox(height: height * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
