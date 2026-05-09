import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/media.dart';
import 'package:movie_show_watchlist/classes/model.dart';
import 'package:movie_show_watchlist/classes/custom_widgets.dart';
import 'package:scoped_model/scoped_model.dart';

//test cards
final List<Media> testList = [
  Media(
    id: 0,
    title: 'The Movie',
    genres: [Genre.action, Genre.animation],
    status: Status.watched,
    type: MediaType.movies,
  ),
  Media(
    id: 1,
    title: 'The TV Show',
    genres: [Genre.horror, Genre.mystery],
    status: Status.notWatched,
    type: MediaType.tvShows,
  ),
  Media(
    id: 2,
    title: 'The Movie2',
    genres: [Genre.scifi, Genre.adventure, Genre.fantasy],
    status: Status.watching,
    type: MediaType.movies,
  ),
  Media(
    id: 3,
    title: 'The TV Show2',
    genres: [Genre.crime, Genre.documentary],
    status: Status.dropped,
    type: MediaType.tvShows,
  ),
];

class HomeScreen extends StatefulWidget {
  final AppModel model;
  final Function(int)? onTabChange;
  const HomeScreen({super.key, required this.model, this.onTabChange});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int selectTab = 0;
  Genre? selectGenre;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        final allMedia = [...widget.model.movieList, ...widget.model.showList];

        final filteredList = allMedia.where((m) {
          if (selectTab == 1 && m.type != MediaType.movies) return false;
          if (selectTab == 2 && m.type != MediaType.tvShows) return false;

          if (selectGenre != null) {
            if (m.genres == null) return false;
            if (!m.genres!.contains(selectGenre)) return false;
          }

          if (searchQuery.isNotEmpty) {
            if (!m.title.toLowerCase().contains(searchQuery)) return false;
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
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () async {
                          final result = await showMenu<Genre?>(
                            context: context,
                            position: const RelativeRect.fromLTRB(
                              100,
                              80,
                              0,
                              0,
                            ),
                            items: [
                              const PopupMenuItem(child: Text("All Genres")),
                              ...Genre.values.map(
                                (g) => PopupMenuItem(
                                  child: Text(g.name),
                                  value: g,
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
                      SizedBox(width: 5),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectTab = 0;
                            selectGenre = null;
                          });
                        },
                        icon: Icon(Icons.refresh),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => selectTab = 1),
                          child: Text("Movies"),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => selectTab = 2),
                          child: Text("TV Shows"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      itemCount: filteredList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 170 / 270,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        final Media media = filteredList[index];
                        return Column(
                          children: [
                            Expanded(
                              child: MediaCard(
                                width: 170,
                                height: 250,
                                mediaItem: media,
                                onClick: () {
                                  widget.model.selectMedia(media);
                                  widget.onTabChange?.call(2);
                                },
                              ),
                            ),
                            // show stars only if rated
                            if (media.rating != null && media.rating! > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (i) {
                                    final full = (i + 1).toDouble();
                                    final half = i + 0.5;
                                    return Icon(
                                      media.rating! >= full
                                          ? Icons.star
                                          : media.rating! >= half
                                          ? Icons.star_half
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 14,
                                    );
                                  }),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
