import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/custom_widgets.dart';
import 'package:movie_show_watchlist/classes/media.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemScreen extends StatefulWidget {

  final TmdbModel model;
  const ItemScreen({super.key, required this.model});

  @override
  State<ItemScreen> createState() => _ItemScreen();
}

class _ItemScreen extends State<ItemScreen> {

  late Future<List<Media>> _movies;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _movies = widget.model.getSearchMovies("");
  }
  
  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<TmdbModel>(
      builder: (context, child, model) {
        return Scaffold(
          body: Center(
            child: Column(
              children: [

                SearchBar().showAll(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                      _movies = widget.model.getSearchMovies(_searchQuery);
                    });
                    print("Query: $value");
                  }
                ),

                FutureBuilder<List<Media>>(
                  future: _movies,
                  builder: (BuildContext context, AsyncSnapshot<List<Media>> snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    else {

                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {

                              final movie = snapshot.data![index];
                              final genres = movie.genres ?? [];
                              final directors = movie.directors ?? [];

                              return Align(
                                alignment: .topCenter,
                                child: Container(
                                  width: 100,
                                  height: 500,
                                  child: Column(
                                    children: [

                                      Text(movie.title),

                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: genres.length,
                                          itemBuilder: (BuildContext context, int gIndex) {
                                            return Text(genres[gIndex].label);
                                          }
                                        )
                                      ),

                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: directors.length,
                                          itemBuilder: (BuildContext context, int gIndex) {
                                            return Text(directors[gIndex]);
                                          }
                                        )
                                      ),

                                      (movie.posterPath != "")
                                      ? Image.network(movie.posterPath ?? "")
                                      : Text("No image found.")

                                    ],
                                  )
                                ),
                              );
                            },
                          ),
                        );
                      }
                      else {
                        return Center(
                          child: Text(
                            "No movies found.",
                          )
                        );
                      }
                    }
                  },
                )

              ],
            )
          )
        );
      },
    );
  }
}