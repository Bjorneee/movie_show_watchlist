import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/media.dart';
import 'package:movie_show_watchlist/classes/model.dart';
import 'package:movie_show_watchlist/classes/custom_widgets.dart';

final Media test = Media(
  title: 'The Movie',
  status: Status.watched // Status changes card overlay color
);

class HomeScreen extends StatefulWidget {

  final AppModel model;
  const HomeScreen({super.key, required this.model});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SearchBar().showAll()
      )
    );
  }
}