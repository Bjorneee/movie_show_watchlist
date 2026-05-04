import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/model.dart';
import 'package:movie_show_watchlist/classes/media.dart';
import 'package:movie_show_watchlist/classes/custom_widgets.dart';

class AddScreen extends StatefulWidget {

  final AppModel model;
  const AddScreen({super.key, required this.model});

  @override
  State<AddScreen> createState() => _AddScreen();
}

class _AddScreen extends State<AddScreen> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text("My Watch List")),
        body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Add Movie/TV Show",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),

                  SearchBar().showAll(),      //search bar
                  SizedBox(height: 15),

                  Center(                     //movie/tv show pic
                    child: SizedBox(
                      width: 160,
                      height: 220,
                      child: MediaCard(
                          mediaItem: Media(
                              title: "+",
                              type: MediaType.movies,
                          ),
                      ),
                    )
                  ),
                  SizedBox(height: 15),

                  Text("Title"),              //title field
                  SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Enter title here",
                    ),
                  ),
                  SizedBox(height: 10),

                  Text("Genre(s)"),              //genre field
                  SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Enter genre(s) here",
                    ),
                  ),
                  SizedBox(height: 10),

                  Text("Director(s)"),              //director field
                  SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Enter director(s) here",
                    ),
                  ),
                  SizedBox(height: 20),

                  SizedBox(                         //submit button
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Add"),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )
        )
    );
  }
}