import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/model.dart';


class AddScreen extends StatefulWidget {

  final AppModel model;
  const AddScreen({super.key, required this.model});

  @override
  State<AddScreen> createState() => _AddScreen();
}

class _AddScreen extends State<AddScreen> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(body: Text('Add'));
  }
}