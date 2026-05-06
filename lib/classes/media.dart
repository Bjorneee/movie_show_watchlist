/* Data classes for movie/show items */

import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:movie_show_watchlist/api/tmdb_api.dart';


enum Genre {
  action("Action", 28),
  adventure("Adventure", 12),
  actionAdventure("Action & Adventure", 10759),
  animation("Animation", 16),
  comedy("Comedy", 35),
  crime("Crime", 80),
  documentary("Documentary", 99),
  drama("Drama", 18),
  family("Family", 10751),
  kids("Kids", 10762),
  fantasy("Fantasy", 14),
  history("History", 36),
  horror("Horror", 27),
  music("Music", 10402),
  mystery("Mystery", 9648),
  news("News", 10763),
  reality("Reality", 10764),
  romance("Romance", 10749),
  scifi("Science Fiction", 878),
  scifiFantasy("Sci-Fi & Fantasy", 10765),
  soap("Soap", 10766),
  talk("Talk", 10767),
  thriller("Thriller", 53),
  war("War", 10752),
  warPolitics("War & Politics", 10768),
  western("Western", 37),
  unknown("Unknown", 0);

  final String label;
  final int id;

  const Genre(this.label, this.id);

  static Genre fromId(int id) {
    return Genre.values.firstWhere(
      (g) => g.id == id,
      orElse: () => Genre.unknown
    );
  }
}

enum Status {
  notWatched('Not Watched', Colors.transparent),
  watching('Watching', Color.fromARGB(255, 0, 130, 4)),
  watched('Watched', Colors.black),
  dropped('Dropped', Color.fromARGB(255, 130, 4, 0));

  final String string;
  final Color color;
  const Status(this.string, this.color);
}

enum MediaType {
  movies,
  tvShows;
}

class Media {
  int id;
  String title;
  List<Genre>? genres;
  List<String>? directors;
  String? posterPath;
  Status status;
  final MediaType type;

  Media ({
    required this.id,
    required this.title,
    this.genres,
    this.directors,
    this.posterPath,
    this.status = Status.notWatched,
    required this.type
  });

  factory Media.fromJson(Map<String, dynamic> json, MediaType type) {

    final genreData = json['genre_ids'];
    List<Genre>? genres = [];

    if (genreData is List) {
      genres = genreData.map((item) => Genre.fromId((int.tryParse(item.toString())) ?? 0)).toList();
    }

    return Media(
      id: json['id'],
      title: (type == MediaType.movies) ? json['title'] : json['name'],
      genres: genres,
      directors: null,
      posterPath: getPosterUrl(json['poster_path']),
      type: type
    );
  }

  static Future<Media> fromJsonAsync(Map<String, dynamic> json, MediaType type) async {
    
    final media = Media.fromJson(json, type);
    media.directors = (type == MediaType.movies)
      ? await getMovieDirectorsAsync(media.id)
      : await getTVDirectorsAsync(media.id);

    return media;
  }

  Future<int?> getDirectors() async {
    directors = (type == MediaType.movies) ? await getMovieDirectorsAsync(id) : await getTVDirectorsAsync(id);
    return directors?.length;
  }

}

mixin TmdbModel on Model {

  List<Media> _tmdbMovies = [];
  List<Media> _tmdbShows = [];

  List<Media> get tmdbMovies => _tmdbMovies;
  List<Media> get tmdbShows => _tmdbShows;

  Future<List<Media>> getSearchMovies(String query) async {

    if (query.trim().isEmpty) {
      _tmdbMovies = [];
      notifyListeners();
      return _tmdbMovies;
    }

    List<dynamic> jsonData = await searchMovies(query);

    _tmdbMovies = await Future.wait(
      jsonData.map((item) => Media.fromJsonAsync(item, MediaType.movies)),
    );
    notifyListeners();
    return _tmdbMovies;
  }

  Future<List<Media>> getSearchTV(String query) async {

    if (query.trim().isEmpty) {
      _tmdbShows = [];
      notifyListeners();
      return _tmdbShows;
    }

    List<dynamic> jsonData = await searchTV(query);
    _tmdbShows = await Future.wait(
      jsonData.map((item) => Media.fromJsonAsync(item, MediaType.tvShows)),
    );
    notifyListeners();
    return _tmdbShows;
  }

}