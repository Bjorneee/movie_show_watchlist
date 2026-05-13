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
          appBar: AppBar(title: const Text('My Watch List')),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsetsGeometry.all(16),
              child: Form(
                key: _formKey,
                child: Stack(
                  alignment: .topCenter,
                  children: [

                    Column(
                      mainAxisAlignment: .spaceBetween,
                      crossAxisAlignment: .start,
                      children: [

                        Center(
                          child: Text(
                            "Add Movie/TV Show",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isMovies = true;
                                    _selectedMedia = null;
                                    titleController.clear();
                                    genreController.clear();
                                    directorController.clear();
                                    _mediaResults = widget.model.getSearchMovies(_searchQuery);
                                  });
                                },
                                child: const Text("Movies"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isMovies = false;
                                    _selectedMedia = null;
                                    titleController.clear();
                                    genreController.clear();
                                    directorController.clear();
                                    _mediaResults = widget.model.getSearchTV(_searchQuery);
                                  });
                                },
                                child: const Text("TV Shows"),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        SearchBar().showAll(      //search bar
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
                        ),

                        SizedBox(height: 15),

                        Center(                     //movie/tv show pic
                            child: SizedBox(
                              width: 200,
                              height: 300,
                              child: MediaCard(
                                mediaItem: _selectedMedia == null
                                ?
                                Media(
                                  id: 0,
                                  title: "+",
                                  type: _isMovies ? MediaType.movies : MediaType.tvShows,
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
                        /*SizedBox(height: 10),

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
                          /*validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Director is missing";
                            }
                            return null;
                          },*/
                        ),*/
                        SizedBox(height: 20),

                        SizedBox(                         //submit button
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              //validate all input field when clicking Submit button
                              if (_formKey.currentState!.validate()) {
                                final newMedia = Media(
                                  id: _selectedMedia?.id ?? DateTime.now().millisecondsSinceEpoch,
                                  title: titleController.text.trim(),
                                  genres: _selectedMedia?.genres ??
                                      genreController.text
                                          .split(',')
                                          .map((g) => g.trim())
                                          .map((g) => Genre.values.firstWhere(
                                            (e) => e.label.toLowerCase() == g.toLowerCase(),
                                        orElse: () => Genre.unknown,
                                      ))
                                          .toList(),
                                  directors: directorController.text
                                      .split(',')
                                      .map((d) => d.trim())
                                      .where((d) => d.isNotEmpty)
                                      .toList(),
                                  posterPath: _selectedMedia?.posterPath,
                                  type: _isMovies ? MediaType.movies : MediaType.tvShows,
                                );

                                if (_isMovies) {
                                  widget.model.addMovie(newMedia);
                                } else {
                                  widget.model.addShow(newMedia);
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Adding to list successfully")),
                                );

                                // clear form
                                titleController.clear();
                                genreController.clear();
                                directorController.clear();
                                setState(() {
                                  _selectedMedia = null;
                                });
                              }
                            },
                            child: Text("Add"),
                          ),
                        ),
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
                    : const SizedBox.shrink()
                  ],
                )
              )
            )
          )
        );
      }
    );
  }
}