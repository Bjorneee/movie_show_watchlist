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
  
  @override
  Widget build(BuildContext context) {

    return Text("Item Screen");
  }
}