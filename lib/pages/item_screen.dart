import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/model.dart';


class ItemScreen extends StatefulWidget {

  final AppModel model;
  const ItemScreen({super.key, required this.model});

  @override
  State<ItemScreen> createState() => _ItemScreen();
}

class _ItemScreen extends State<ItemScreen> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(body: Text('Menu'));
  }
}