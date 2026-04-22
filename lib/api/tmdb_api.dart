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

// To get image: Follow same steps as before but with image base and append the posterpath returned from the corresponding result