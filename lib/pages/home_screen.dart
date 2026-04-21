import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/model.dart';


class HomeScreen extends StatefulWidget {

  final AppModel model;
  const HomeScreen({super.key, required this.model});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(body: Text('Home'));
  }
}