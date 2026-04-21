/* Data classes for movie/show items */

import 'package:flutter/material.dart';

enum Genre {
  action,
  adventure,
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
  notWatched,
  watching,
  watched,
  dropped
}

class Media {

  String title;
  List<Genre>? genres;
  List<String>? directors;
  AssetImage? coverImage;
  Status status;

  Media ({
    required this.title,
    this.genres,
    this.directors,
    this.coverImage,
    this.status = Status.notWatched
  });

}