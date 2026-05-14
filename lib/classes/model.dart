import 'package:scoped_model/scoped_model.dart';

import 'package:movie_show_watchlist/classes/media.dart';
import 'package:movie_show_watchlist/database/database_helper.dart';

mixin AppModel on Model {
  final List<Media> _movieList = [];
  final List<Media> _showList = [];

  List<Media> get movieList => _movieList;
  List<Media> get showList => _showList;

  Media? _selectedMedia;
  Media? get selectedMedia => _selectedMedia;

  Future<void> loadSavedMedia() async {
    final savedMedia = await DatabaseHelper.instance.getAllMedia();

    _movieList.clear();
    _showList.clear();

    for (final media in savedMedia) {
      if (media.type == MediaType.movies) {
        _movieList.add(media);
      } else {
        _showList.add(media);
      }
    }

    notifyListeners();
  }
  /* Add a movie to the movie list */
  Future<void> addMovie(Media movie) async {
    await DatabaseHelper.instance.insertMedia(movie);
    _movieList.removeWhere((item) => item.id == movie.id);
    _movieList.add(movie);
    notifyListeners();
  }
  /* Add a show to the show list */
  Future<void> addShow(Media show) async {
    await DatabaseHelper.instance.insertMedia(show);
    _showList.removeWhere((item) => item.id == show.id);
    _showList.add(show);
    notifyListeners();
  }

  Future<void> updateMedia(Media media) async {
    await DatabaseHelper.instance.updateMedia(media);
    notifyListeners();
  }

  Future<void> updateStatus(Media media, Status status) async {
    media.status = status;
    await DatabaseHelper.instance.updateStatus(
      id: media.id,
      type: media.type,
      status: status,
    );
    notifyListeners();
  }

  /* Mark a movie/show as not-watched */
  Future<void> markNotWatched(List<Media> list, int idx) async {
    await updateStatus(list[idx], Status.notWatched);

  }

  /* Mark a movie/show as watched */
  Future<void> markWatched(List<Media> list, int idx) async {
    await updateStatus(list[idx], Status.watched);;

  }
  
  /* Mark a movie/show as being watched */
  Future<void> markWatching(List<Media> list, int idx) async {
    await updateStatus(list[idx], Status.watching);

  }

  /* Mark a movie/show as dropped */
  Future<void> markDropped(List<Media> list, int idx) async {
    await updateStatus(list[idx], Status.dropped);

  }

  /* Select a media */
  void selectMedia(Media? media) {
    _selectedMedia = media;
    notifyListeners();
  }

  //delete a media
  Future<void> deleteMedia(Media media) async {
    await DatabaseHelper.instance.deleteMedia(media);
    
    if (media.type == MediaType.movies) {
      _movieList.removeWhere((item) => item.id == media.id);
    } else {
      _showList.removeWhere((item) => item.id == media.id);
    }
    _selectedMedia = null;
    notifyListeners();
  }
}

class MainModel extends Model with AppModel, TmdbModel {}