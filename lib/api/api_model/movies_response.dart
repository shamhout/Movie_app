class MoviesResponse {
  MoviesResponse({
    this.status,
    this.statusMessage,
    this.data,
  });

  MoviesResponse.fromJson(dynamic json) {
    status = json['status'];
    statusMessage = json['status_message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  String? status;
  String? statusMessage;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['status_message'] = statusMessage;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    this.movies,
  });

  Data.fromJson(dynamic json) {
    if (json['movies'] != null) {
      movies = [];
      json['movies'].forEach((v) {
        movies?.add(Movies.fromJson(v));
      });
    }
  }

  List<Movies>? movies;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (movies != null) {
      map['movies'] = movies?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Movies {
  Movies({
    this.id,
    this.largeCoverImage,
    this.rating,
  });

  Movies.fromJson(dynamic json) {
    id = json['id'];
    largeCoverImage = json['large_cover_image'];
    rating = (json['rating'] as num?)?.toDouble();
  }

  int? id;
  String? largeCoverImage;
  double? rating;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['large_cover_image'] = largeCoverImage;
    map['rating'] = rating;
    return map;
  }
}
