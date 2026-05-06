import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/model.dart';
import 'package:movie_show_watchlist/classes/media.dart';
import 'package:movie_show_watchlist/classes/custom_widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class AddScreen extends StatefulWidget {

  final MainModel model;
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

  late Future<List<Media>> _mediaResults;
  String _searchQuery = "";
  bool _showSearchResults = false;
  bool _isMovies = true;
  Media? _selectedMedia;

  @override
  void initState() {
    super.initState();
    _mediaResults = widget.model.getSearchMovies("");
  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Stack(
                  alignment: .topCenter,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),

                        SearchBar().showAll(
                          onTap: () {
                            setState(() {
                              _showSearchResults = true;
                            });
                          },
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                              _mediaResults = _isMovies
                                ? widget.model.getSearchMovies(_searchQuery)
                                : widget.model.getSearchTV(_searchQuery);
                            });
                          },
                        ),      //search bar

                        SizedBox(height: 15),

                        Center(                     //movie/tv show pic
                            child: SizedBox(
                              width: 160,
                              height: 220,
                              child: MediaCard(
                                mediaItem: _selectedMedia == null
                                ?
                                Media(
                                  id: 0,
                                  title: "+",
                                  type: MediaType.movies,
                                )
                                :_selectedMedia!
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

                    (_showSearchResults)
                    ? 
                    FutureBuilder(
                      future: _mediaResults,
                      builder: (BuildContext context, AsyncSnapshot<List<Media>> snapshot) {
                        
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else {

                          if (snapshot.hasData) {
                            return Container(
                              margin: EdgeInsets.only(top: 75),
                              width: 375,
                              constraints: BoxConstraints(maxHeight: 600),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.shadow,
                                    blurRadius: 10
                                  )
                                ]
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {

                                  final media = snapshot.data![index];

                                  return MediaListTile(
                                    mediaItem: media,
                                    onClick: () {
                                      setState(() {

                                        _selectedMedia = media;

                                        titleController.text = media.title;
                                        genreController.text = media.genres
                                          ?.map((genre) => genre.label)
                                          .join(", ") ?? "";

                                        directorController.text = media.directors?.join(", ") ?? "";

                                        _showSearchResults = false;
                                      });
                                    },
                                  );
                                },
                              )
                            );
                          } else {
                            return Center(
                              child: Text("No media found.")
                            );
                          }
                        }
                      }
                    )
                    : Text("")
                  ],
                )
              )
            ),
          )
        );
      }
    );
  }
}