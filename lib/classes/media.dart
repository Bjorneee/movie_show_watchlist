/* Data classes for movie/show items */

import 'package:flutter/material.dart';

enum Genre {
  action,
  adventure,
  animation,
  biography,
  comedy,
  crime,
  documentary,
  drama,
  family,
  fantasy,
  history,
  horror,
  musical,
  mystery,
  news,
  reality,
  romance,
  scifi,
  thriller,
  war,
  western
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
  String title;
  List<Genre>? genres;
  List<String>? directors;
  String? coverImagePath;
  Status status;
  final MediaType type;

  Media ({
    required this.title,
    this.genres,
    this.directors,
    this.coverImagePath,
    this.status = Status.notWatched,
    required this.type
  });
}