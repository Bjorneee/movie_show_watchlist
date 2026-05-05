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
  final _formKey = GlobalKey<FormState>();  //add form key to validate the form

  //controllers to store user input
  final TextEditingController titleController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController directorController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text("My Watch List")),
        body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
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

                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Title",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(                  //title field
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Enter title here",
                        errorStyle: TextStyle(fontSize: 17)
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Title is missing";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    Padding(                //genre field
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Genre(s)",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: genreController,
                      decoration: InputDecoration(
                        hintText: "Enter genre(s) here",
                        errorStyle: TextStyle(fontSize: 17)
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Genre is missing";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    Padding(                //director field
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Director(s)",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: directorController,
                      decoration: InputDecoration(
                        hintText: "Enter director(s) here",
                        errorStyle: TextStyle(fontSize: 17)
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Director is missing";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    SizedBox(                         //submit button
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          //validate all input field when clicking Submit button
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Adding to list successfully")),
                            );
                          }
                        },
                        child: Text("Add"),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              )
            ),
        )
    );
  }
}