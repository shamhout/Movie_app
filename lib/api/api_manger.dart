import 'dart:convert';

import 'package:movie_app/api/api_model/movies_response.dart';
import 'package:movie_app/api/endpoints.dart';
import 'package:http/http.dart' as http;

class ApiManager {
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
}
