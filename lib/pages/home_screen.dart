import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/media.dart';
import 'package:movie_show_watchlist/classes/model.dart';
import 'package:movie_show_watchlist/classes/custom_widgets.dart';
import 'package:movie_show_watchlist/api/tmdb_api.dart';
import 'package:movie_show_watchlist/main.dart';

//test cards
final List<Media> testList = [
  Media(title: 'The Movie', genres: [Genre.action, Genre.animation], status: Status.watched, type: MediaType.movies), // Status changes card overlay color
  Media(title: 'The TV Show', genres: [Genre.horror, Genre.mystery], status: Status.notWatched, type: MediaType.tvShows),
  Media(title: 'The Movie2', genres: [Genre.scifi, Genre.adventure, Genre.fantasy], status: Status.watching, type: MediaType.movies),
  Media(title: 'The TV Show2', genres: [Genre.crime, Genre.documentary], status: Status.dropped, type: MediaType.tvShows)
];

class HomeScreen extends StatefulWidget {

  final AppModel model;
  const HomeScreen({super.key, required this.model});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int selectTab = 0; // 0 = default, 1 = movies, 2 = shows
  Genre? selectGenre;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredList = testList.where((m) {
      //filter for media type buttons
      if (selectTab == 1 && m.type != MediaType.movies) {
        return false;
      }
      if (selectTab == 2 && m.type != MediaType.tvShows) {
        return false;
      }

      //genres filter
      if (selectGenre != null) {
        if (m.genres == null) {
          return false;
        }
        if (!m.genres!.contains(selectGenre)) {
          return false;
        }
      }

      //search added movie/tv show filter
      if (searchQuery.isNotEmpty) {
        if (!m.title.toLowerCase().contains(searchQuery)) {
          return false;
        }
      }

      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("My Watch List")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(            //search bar on the top
                children: [
                  Expanded(
                      child: SearchBar().showAll(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        }
                      )
                  ),
                  SizedBox(width: 10),
                  IconButton(
                      onPressed: () async {
                        final result = await showMenu<Genre?>(
                          context: context,
                          position: const RelativeRect.fromLTRB(100, 80, 0, 0),
                          items: [
                            const PopupMenuItem(
                                child: Text("All Genres"),
                            ),
                            ...Genre.values.map(
                                (g) => PopupMenuItem(
                                  child: Text(g.name),
                                  value: g,
                                )
                            )
                          ]
                        );
                        setState(() {
                          selectGenre = result;
                        });
                      },
                      icon: const Icon(Icons.filter_alt_outlined)
                  ),
                  SizedBox(width: 5),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          selectTab = 0;
                          selectGenre = null;
                        });
                      },
                      icon: Icon(Icons.refresh)
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(          //movies - shows buttons
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectTab = 1;
                            });
                          },
                          child: Text("Movies"),
                      )
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectTab = 2;
                          });
                        },
                        child: Text("TV Shows"),
                      )
                  )
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                  child: GridView.builder(
                      itemCount: filteredList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return MediaCard(
                            mediaItem: filteredList[index]
                        );
                      }
                  )
              )
            ],
          )
        )
      )
    );
  }
}