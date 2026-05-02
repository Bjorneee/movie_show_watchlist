import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/media.dart';
import 'package:movie_show_watchlist/classes/model.dart';
import 'package:movie_show_watchlist/classes/custom_widgets.dart';
import 'package:movie_show_watchlist/pages/item_screen.dart';

// test cards
final List<Media> testList = [
  Media(
    title: 'The Movie',
    genres: [Genre.action, Genre.animation],
    status: Status.watched,
    type: MediaType.movies,
  ),
  Media(
    title: 'The TV Show',
    genres: [Genre.horror, Genre.mystery],
    status: Status.notWatched,
    type: MediaType.tvShows,
  ),
  Media(
    title: 'The Movie2',
    genres: [Genre.scifi, Genre.adventure, Genre.fantasy],
    status: Status.watching,
    type: MediaType.movies,
  ),
  Media(
    title: 'The TV Show2',
    genres: [Genre.crime, Genre.documentary],
    status: Status.dropped,
    type: MediaType.tvShows,
  ),
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
      if (selectTab == 1 && m.type != MediaType.movies) {
        return false;
      }

      if (selectTab == 2 && m.type != MediaType.tvShows) {
        return false;
      }

      if (selectGenre != null) {
        if (m.genres == null) {
          return false;
        }

        if (!m.genres!.contains(selectGenre)) {
          return false;
        }
      }

      if (searchQuery.isNotEmpty) {
        if (!m.title.toLowerCase().contains(searchQuery)) {
          return false;
        }
      }

      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("My Watch List")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SearchBar().showAll(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () async {
                      final result = await showMenu<Genre?>(
                        context: context,
                        position: const RelativeRect.fromLTRB(100, 80, 0, 0),
                        items: [
                          const PopupMenuItem<Genre?>(
                            value: null,
                            child: Text("All Genres"),
                          ),
                          ...Genre.values.map(
                            (g) => PopupMenuItem<Genre?>(
                              value: g,
                              child: Text(g.name),
                            ),
                          ),
                        ],
                      );

                      setState(() {
                        selectGenre = result;
                      });
                    },
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectTab = 0;
                        selectGenre = null;
                        searchQuery = "";
                      });
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectTab = 1;
                        });
                      },
                      child: const Text("Movies"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectTab = 2;
                        });
                      },
                      child: const Text("TV Shows"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(
                child: GridView.builder(
                  itemCount: filteredList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    final Media media = filteredList[index];

                    return MediaCard(
                      mediaItem: media,
                      onClick: () async {
                        final bool? wasEdited = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ItemScreen(model: widget.model, media: media),
                          ),
                        );

                        if (wasEdited == true) {
                          setState(() {});
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
