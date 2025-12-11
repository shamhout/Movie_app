import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/api/api_manger.dart';
import 'package:movie_app/api/api_model/movies_response.dart';
import 'package:movie_app/l10n/app_localizations.dart';
import 'package:movie_app/ui/home_tab/movies_item/movies_item.dart';
import 'package:movie_app/utils/app_assets.dart';
import 'package:movie_app/utils/app_color.dart';
import 'package:movie_app/utils/app_route.dart';
import 'package:movie_app/utils/app_style.dart';

class Hometabitem extends StatefulWidget {
  Hometabitem({required this.movieList, super.key});

  List<Movies> movieList;

  @override
  State<Hometabitem> createState() => _HometabitemState();
}

class _HometabitemState extends State<Hometabitem> {
  int currentIndex = 0;
  List<Movies> actionMoviesList = [];
  List<Movies> dramaMoviesList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadActionMovies();
    loadDramaMovies();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        color: AppColor.yellow,
      ));
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.7,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      child: Image.network(
                        widget.movieList[currentIndex].largeCoverImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[900],
                            child: Center(
                              child: Icon(Icons.movie,
                                  size: 100, color: Colors.grey[700]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x00121312),
                            Color(0x78121312),
                            Color(0xFF121312),
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      SizedBox(
                          height: height * 0.1,
                          child: Image.asset(
                            AppAssets.availableNow,
                            fit: BoxFit.fill,
                          )),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: height * 0.42,
                          autoPlay: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                        ),
                        items: widget.movieList.map((movie) {
                          return MoviesItem(movie: movie);
                        }).toList(),
                      ),
                      SizedBox(
                          height: height * 0.15,
                          child: Image.asset(
                            AppAssets.watchNow,
                            fit: BoxFit.fill,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.02,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Action',
                        style: AppStyle.reglur20white,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoute.seeMoreScreen,
                            arguments: {
                              "title": "Action Movies",
                              "movies": actionMoviesList,
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              appLocalizations.seeMore,
                              style: AppStyle.reglur16yellow,
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: AppColor.yellow,
                              size: 20,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    height: height * 0.25,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoute.movieDetailsScreen,
                                arguments: actionMoviesList[index].id);
                          },
                          child: Container(
                            width: width * 0.5,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      actionMoviesList[index].largeCoverImage!),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.02,
                                      vertical: height * 0.01),
                                  width: width * 0.15,
                                  height: height * 0.05,
                                  decoration: BoxDecoration(
                                      color: AppColor.blackTransparentColor,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${actionMoviesList[index].rating}',
                                        style: AppStyle.bold16White,
                                      ),
                                      const SizedBox(
                                        width: 5,
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
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: width * 0.05,
                        );
                      },
                      itemCount: actionMoviesList.length,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02, vertical: height * 0.02),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Drama',
                        style: AppStyle.reglur20white,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoute.seeMoreScreen,
                            arguments: {
                              "title": "Drama Movies",
                              "movies": dramaMoviesList,
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              appLocalizations.seeMore,
                              style: AppStyle.reglur16yellow,
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: AppColor.yellow,
                              size: 20,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    height: height * 0.25,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoute.movieDetailsScreen,
                                arguments: dramaMoviesList[index].id);
                          },
                          child: Container(
                            width: width * 0.5,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      dramaMoviesList[index].largeCoverImage!),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.02,
                                      vertical: height * 0.01),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.005,
                                      vertical: height * 0.003),
                                  width: width * 0.15,
                                  height: height * 0.05,
                                  decoration: BoxDecoration(
                                      color: AppColor.blackTransparentColor,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${dramaMoviesList[index].rating}',
                                        style: AppStyle.bold16White,
                                      ),
                                      const SizedBox(
                                        width: 5,
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
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: width * 0.05,
                        );
                      },
                      itemCount: dramaMoviesList.length,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadActionMovies() async {
    var response = await ApiManager.getMoviesByGenre("Action");
    setState(() {
      actionMoviesList = response.data!.movies!;
      isLoading = false;
    });
  }

  void loadDramaMovies() async {
    var response = await ApiManager.getMoviesByGenre("Drama");
    setState(() {
      dramaMoviesList = response.data!.movies!;
      isLoading = false;
    });
  }
}
