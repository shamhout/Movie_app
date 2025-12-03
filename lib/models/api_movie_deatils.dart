class MovieModel {
  final int? id;
  final String? url;
  final String? imdbCode;
  final String? title;
  final String? titleEnglish;
  final String? titleLong;
  final String? slug;
  final int? year;
  final double? rating;
  final int? runtime;
  final List<String>? genres;

  final int? likeCount;

  final String? descriptionIntro;
  final String? descriptionFull;

  final String? ytTrailerCode;
  final String? language;
  final String? mpaRating;

  final String? backgroundImage;
  final String? backgroundImageOriginal;

  final String? smallCoverImage;
  final String? mediumCoverImage;
  final String? largeCoverImage;

  final List<String>? mediumScreenshots;
  final List<String>? largeScreenshots;

  final List<ActorModel>? cast;
  final List<TorrentModel>? torrents;

  MovieModel({
    this.id,
    this.url,
    this.imdbCode,
    this.title,
    this.titleEnglish,
    this.titleLong,
    this.slug,
    this.year,
    this.rating,
    this.runtime,
    this.genres,
    this.likeCount,
    this.descriptionIntro,
    this.descriptionFull,
    this.ytTrailerCode,
    this.language,
    this.mpaRating,
    this.backgroundImage,
    this.backgroundImageOriginal,
    this.smallCoverImage,
    this.mediumCoverImage,
    this.largeCoverImage,
    this.mediumScreenshots,
    this.largeScreenshots,
    this.cast,
    this.torrents,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      url: json['url'],
      imdbCode: json['imdb_code'],
      title: json['title'],
      titleEnglish: json['title_english'],
      titleLong: json['title_long'],
      slug: json['slug'],
      year: json['year'],
      rating: json['rating']?.toDouble(),
      runtime: json['runtime'],
      genres: json['genres'] != null ? List<String>.from(json['genres']) : null,
      likeCount: json['like_count'],
      descriptionIntro: json['description_intro'],
      descriptionFull: json['description_full'],
      ytTrailerCode: json['yt_trailer_code'],
      language: json['language'],
      mpaRating: json['mpa_rating'],
      backgroundImage: json['background_image'],
      backgroundImageOriginal: json['background_image_original'],
      smallCoverImage: json['small_cover_image'],
      mediumCoverImage: json['medium_cover_image'],
      largeCoverImage: json['large_cover_image'],
      mediumScreenshots: List<String>.from([
        json['medium_screenshot_image1'],
        json['medium_screenshot_image2'],
        json['medium_screenshot_image3'],
      ].where((e) => e is String && e.isNotEmpty)),
      largeScreenshots: List<String>.from([
        json['large_screenshot_image1'],
        json['large_screenshot_image2'],
        json['large_screenshot_image3'],
      ].where((e) => e is String && e.isNotEmpty)),
      cast: json['cast'] != null ? (json['cast'] as List).map((e) => ActorModel.fromJson(e)).toList() : null,
      torrents: json['torrents'] != null ? (json['torrents'] as List).map((e) => TorrentModel.fromJson(e)).toList() : null,
    );
  }
}

class ActorModel {
  final String? name;
  final String? characterName;
  final String? urlSmallImage;

  ActorModel({this.name, this.characterName, this.urlSmallImage});

  factory ActorModel.fromJson(Map<String, dynamic> json) {
    return ActorModel(
      name: json['name'],
      characterName: json['character_name'],
      urlSmallImage: json['url_small_image'],
    );
  }
}

class TorrentModel {
  final String? url;
  final String? hash;
  final String? quality;
  final String? type;
  final String? size;

  TorrentModel({this.url, this.hash, this.quality, this.type, this.size});

  factory TorrentModel.fromJson(Map<String, dynamic> json) {
    return TorrentModel(
      url: json['url'],
      hash: json['hash'],
      quality: json['quality'],
      type: json['type'],
      size: json['size'],
    );
  }
}
