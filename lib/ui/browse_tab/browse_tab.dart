import 'package:flutter/material.dart';
import 'package:movie_app/api/api_manger.dart';
import 'package:movie_app/api/api_model/movies_response.dart';
import 'package:movie_app/utils/app_color.dart';

import '../../utils/app_route.dart';

class BrowseTab extends StatefulWidget {
  const BrowseTab({super.key});

  @override
  State<BrowseTab> createState() => _MoviesCategoryScreenState();
}

class _MoviesCategoryScreenState extends State<BrowseTab> {
  List<String> genres = [
    "Action",
    "Adventure",
    "Animation",
    "Biography",
    "Comedy"
  ];
  String selectedGenre = "Action";

  Future<MoviesResponse>? moviesFuture;

  ScrollController scrollController = ScrollController();
  List moviesList = [];
  int page = 1;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    moviesFuture = loadMovies();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });
  }

  Future<MoviesResponse> loadMovies() async {
    var response =
        await ApiManager.getMoviesByGenreandPage(selectedGenre, page);
    moviesList = response.data?.movies ?? [];
    return response;
  }

  Future<void> loadMore() async {
    if (isLoadingMore) return;

    setState(() => isLoadingMore = true);

    page++;
    var response =
        await ApiManager.getMoviesByGenreandPage(selectedGenre, page);

    var moreMovies = response.data?.movies ?? [];
    moviesList.addAll(moreMovies);

    setState(() => isLoadingMore = false);
  }

  void changeGenre(String g) {
    setState(() {
      selectedGenre = g;

      page = 1;
      moviesList.clear();

      moviesFuture = loadMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: height * .07,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                bool active = genres[index] == selectedGenre;
                return GestureDetector(
                  onTap: () => changeGenre(genres[index]),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: height * .02,
                    ),
                    decoration: BoxDecoration(
                      color: active ? AppColor.yellow : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.yellow, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        genres[index],
                        style: TextStyle(
                          color: active ? Colors.black : AppColor.yellow,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(width: 10),
              itemCount: genres.length,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<MoviesResponse>(
              future: moviesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: AppColor.yellow,
                  ));
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error loading movies"));
                }

                var movies = moviesList;

                return GridView.builder(
                  controller: scrollController,
                  // ADDED
                  padding: EdgeInsets.symmetric(horizontal: width * .03),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .6,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),

                  itemCount: movies.length + 1,
                  itemBuilder: (context, index) {
                    if (index == movies.length) {
                      return isLoadingMore
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: AppColor.yellow))
                          : SizedBox();
                    }

                    var movie = movies[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoute.movieDetailsScreen,
                          arguments: movie.id,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            Image.network(
                              movie.mediumCoverImage ?? "",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned(
                              top: 6,
                              left: 6,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColor.blackTransparentColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      movie.rating.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(Icons.star,
                                        color: AppColor.yellow, size: 14),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}