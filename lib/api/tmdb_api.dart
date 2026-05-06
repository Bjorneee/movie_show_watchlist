import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_show_watchlist/env/env.dart';

Future<List<dynamic>> searchMovies(String query) async {
  final apiKey = Env.apiKey;

  final url = Uri.parse(
    '${Env.baseURL}/search/movie?query=$query&api_key=$apiKey'
  );

  final result = await http.get(url);

  if (result.statusCode == 200) {
    return json.decode(result.body)['results'];
  }
  else {
    throw Exception('Response Code ${result.statusCode}: Unable to retrieve movie data.');
  }

}

Future<List<dynamic>> searchTV(String query) async {
  final apiKey = Env.apiKey;

  final url = Uri.parse(
    '${Env.baseURL}/search/tv?query=$query&api_key=$apiKey'
  );

  final result = await http.get(url);

  if (result.statusCode == 200) {
    return json.decode(result.body)['results'];
  }
  else {
    throw Exception('Response Code ${result.statusCode}: Unable to retrieve show data.');
  }
}

String getPosterUrl(String? path) {
  return (path != "" && path != null)
    ? "${Env.imageBaseURL}/w${Env.width}/$path"
    : "";
}

Future<List<dynamic>> getMovieCrew(int moveId) async {
  final apiKey = Env.apiKey;

  final url = Uri.parse(
    "${Env.baseURL}/movie/$moveId/credits?api_key=$apiKey"
  );

  final result = await http.get(url);

  if (result.statusCode == 200) {
    return json.decode(result.body)['crew'];
  }
  throw Exception("Response Code ${result.statusCode}: Unable to retrive crew data.");
}

Future<List<String>> getMovieDirectorsAsync(int movieId) async {
  List<dynamic> jsonData = await getMovieCrew(movieId);
  return jsonData.where(
    (person) => person['job'] == "Director").map<String>(
      (person) => person['name'] as String).toList();
}


Future<List<dynamic>> getTVCrew(int seriesId) async {
  final apiKey = Env.apiKey;

  final url = Uri.parse(
    "${Env.baseURL}/tv/$seriesId/credits?api_key=$apiKey"
  );

  final result = await http.get(url);

  if (result.statusCode == 200) {
    return json.decode(result.body)['crew'];
  }
  throw Exception("Response Code ${result.statusCode}: Unable to retrive crew data.");
}


Future<List<String>> getTVDirectorsAsync(int seriesId) async {
  List<dynamic> jsonData = await getTVCrew(seriesId);
  return jsonData.where(
    (person) => person['job'] == "Director").map<String>(
      (person) => person['name'] as String).toList();
}