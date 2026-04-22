import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/media.dart';
import 'package:movie_show_watchlist/classes/model.dart';
import 'package:movie_show_watchlist/classes/custom_widgets.dart';
import 'package:movie_show_watchlist/main.dart';

//test cards
final List<Media> testList = [
  Media(title: 'The Movie', status: Status.watched, type: MediaType.movies), // Status changes card overlay color
  Media(title: 'The TV Show', status: Status.notWatched, type: MediaType.tvShows),
  Media(title: 'The Movie2', status: Status.watching, type: MediaType.movies),
  Media(title: 'The TV Show2', status: Status.dropped, type: MediaType.tvShows)
];

class HomeScreen extends StatefulWidget {

  final AppModel model;
  const HomeScreen({super.key, required this.model});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int selectTab = 0; // 0 = default, 1 = movies, 2 = shows

  @override
  Widget build(BuildContext context) {
    final filteredList = testList.where((m) {
      if (selectTab == 0) return true;
      if (selectTab == 1) return m.type == MediaType.movies;
      return m.type == MediaType.tvShows;
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
                      child: SearchBar().showAll()
                  ),
                  SizedBox(width: 10),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.filter_alt_outlined)
                  ),
                  SizedBox(width: 5),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          selectTab = 0;
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