import 'dart:convert';

import 'package:movie_app/api/api_model/movies_response.dart';
import 'package:movie_app/api/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/Api_movie_deatils.dart';
import 'package:movie_app/models/api_movie_suggestions.dart';

class ApiManager {


  static Future<MoviesResponse> getMoviesByGenreandPage(String genre, int page) async {
try {
Uri url = Uri.https(
Endpoint.serverName,
Endpoint.apiName,
{
"genre": genre,
"sort_by": "rating",
"page": page.toString(),
},
);

var response = await http.get(url);
return MoviesResponse.fromJson(jsonDecode(response.body));
} catch (e) {
rethrow;
}
}
  static Future<MoviesResponse> getMovies() async {
    try {
      Uri url = Uri.https(Endpoint.serverName, Endpoint.apiName, {"sort_by": 'date_uploaded'});
      var response = await http.get(url);
      return MoviesResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  static Future<MoviesResponse> getMoviesByGenre(String genre) async {
    try {
      Uri url = Uri.https(Endpoint.serverName, Endpoint.apiName, {"genre": genre, "sort_by": 'rating'});
      var response = await http.get(url);
      return MoviesResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  static Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      Uri url = Uri.https(Endpoint.serverName, Endpoint.movieDetailsApiName, {
        "movie_id": movieId.toString(),
        "with_images": "true",
        "with_cast": "true",
      });
      var response = await http.get(url);
      return MovieModel.fromJson(jsonDecode(response.body)['data']['movie']);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<MovieSuggestion>> getMovieSuggestions(int movieId) async {
    try {
      Uri url = Uri.https(
        Endpoint.serverName,
        Endpoint.movieSuggestionsApiName,
        {
          "movie_id": movieId.toString(),
        },
      );

      var response = await http.get(url);
      var jsonData = jsonDecode(response.body);

      List movies = jsonData["data"]["movies"];

      return movies.map((e) => MovieSuggestion.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Movies>> searchMovies(String query) async {
    try {
      Uri url = Uri.https(
        Endpoint.serverName,
        Endpoint.apiName,
        {
          "query_term": query,
        },
      );

      var response = await http.get(url);
      var jsonData = jsonDecode(response.body);

      return MoviesResponse.fromJson(jsonData).data?.movies ?? [];
    } catch (e) {
      rethrow;
    }
  }
}
