class MovieSuggestion {
  final int id;
  final String title;
  final double rating;
  final String image;

  MovieSuggestion({
    required this.id,
    required this.title,
    required this.rating,
    required this.image,
  });

  factory MovieSuggestion.fromJson(Map<String, dynamic> json) {
    return MovieSuggestion(
      id: json["id"],
      title: json["title"],
      rating: (json["rating"] as num).toDouble(),
      image: json["medium_cover_image"] ?? json["large_cover_image"] ?? "",
    );
  }
}
