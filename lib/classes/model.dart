import 'package:scoped_model/scoped_model.dart';

import 'package:movie_show_watchlist/classes/media.dart';

mixin AppModel on Model {

  List<Media> _movieList = [];
  List<Media> _showList = [];

  List<Media> get movieList => _movieList;
  List<Media> get showList => _showList;

  /* Add a movie to the movie list */
  void addMovie(Media movie) {
    _movieList.add(movie);
    notifyListeners();
  }

  /* Add a show to the show list */
  void addShow(Media show) {
    _showList.add(show);
    notifyListeners();
  }

  /* Mark a movie/show as not-watched */
  void markNotWatched(List<Media> list, int idx) {
    list[idx].status = Status.notWatched;
    notifyListeners();
  }

  /* Mark a movie/show as watched */
  void markWatched(List<Media> list, int idx) {
    list[idx].status = Status.watched;
    notifyListeners();
  }
  
  /* Mark a movie/show as being watched */
  void markWatching(List<Media> list, int idx) {
    list[idx].status = Status.watching;
    notifyListeners();
  }

  /* Mark a movie/show as dropped */
  void markDropped(List<Media> list, int idx) {
    list[idx].status = Status.dropped;
    notifyListeners();
  }
}


class MainModel extends Model with AppModel, TmdbModel {}