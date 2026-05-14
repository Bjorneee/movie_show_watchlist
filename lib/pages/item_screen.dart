import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/model.dart';
import 'package:movie_show_watchlist/classes/media.dart';
import 'package:movie_show_watchlist/classes/custom_widgets.dart';

class ItemScreen extends StatefulWidget {
  final AppModel model;
  final Media? media;
  final Function(int)? onTabChange;
  const ItemScreen({
    super.key,
    required this.model,
    this.media,
    this.onTabChange,
  });

  @override
  State<ItemScreen> createState() => _ItemScreen();
}

class _ItemScreen extends State<ItemScreen> {
  late TextEditingController titleController;
  late TextEditingController directorsController;
  late TextEditingController genresController;
  late Status selectedStatus;
  double _rating = 0; // changed to double
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final media = widget.media;

    titleController = TextEditingController(text: media?.title ?? '');

    directorsController = TextEditingController(
      text: media?.directors?.join(', ') ?? '',
    );

    genresController = TextEditingController(
        text: media?.genres
            ?.map((genre) => genre.label)
            .join(', ') ?? '',
    );

    selectedStatus = media?.status ?? Status.notWatched;
    _rating = (media?.rating ?? 0).toDouble(); // cast to double

    // _loadDirectors(media);
  }
  // Future<void> _loadDirectors(Media? media) async {
  //   if (media == null) return;

  //   final names = media.type == MediaType.movies
  //       ? await getMovieDirectorsAsync(media.id)
  //       : await getTVCreatorsAsync(media.id);

  //   if (!mounted) return;

  //   setState(() {
  //     directorsController.text = names.join(', ');
  //   });
  // }

  @override
  void dispose() {
    titleController.dispose();
    directorsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Media? media = widget.media;

    if (media == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              "Tap a movie or TV show from the Home page to view/edit it.",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),

                Center(
                  child: SizedBox(
                    width: 190,
                    height: 260,
                    child: MediaCard(mediaItem: media),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Half-star rating row ─────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final fullValue = (i + 1).toDouble();
                    final halfValue = i + 0.5;
                    return GestureDetector(
                      onTapDown: (details) {
                        setState(() {
                          // left half of icon = half star, right half = full star
                          _rating = details.localPosition.dx < 18
                              ? halfValue
                              : fullValue;
                        });
                      },
                      child: Icon(
                        _rating >= fullValue
                            ? Icons.star
                            : _rating >= halfValue
                            ? Icons.star_half
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 36,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                // ─────────────────────────────────────────────────
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Title is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: directorsController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Director/Creator(s)',
                    //hintText: 'Example: Christopher Nolan, James Gunn',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Color(0xFF93938B)),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: genresController,
                  decoration: InputDecoration(
                    labelText: 'Genre(s)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Genre is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<Status>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: Status.values.map((status) {
                    return DropdownMenuItem<Status>(
                      value: status,
                      child: Text(status.string),
                    );
                  }).toList(),
                  onChanged: (Status? value) {
                    if (value == null) return;
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            media.title = titleController.text.trim();

                            /*media.directors = directorsController.text
                                .split(',')
                                .map((director) => director.trim())
                                .where((director) => director.isNotEmpty)
                                .toList();*/

                            media.genres = genresController.text
                                .split(',')
                                .map((genre) => genre.trim())
                                .where((genre) => genre.isNotEmpty)
                                .map(
                                  (genre) => Genre.values.firstWhere(
                                    (g) => g.label.toLowerCase() == genre.toLowerCase(),
                                orElse: () => Genre.unknown,
                              ),
                            )
                                .toList();

                            media.status = selectedStatus;
                            media.rating = _rating; // saves double
                            await widget.model.updateMedia(media);
                            widget.model.selectMedia(null);
                            widget.onTabChange?.call(0);
                          }
                        },
                        child: Text('Save Changes'),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          await widget.model.deleteMedia(media);
                          widget.onTabChange?.call(0);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Media deleted!"),
                            ),
                          );
                        },
                        child: Text('Delete'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      widget.model.selectMedia(null);   //clear selection
                      widget.onTabChange?.call(0);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
