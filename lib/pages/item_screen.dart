import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/model.dart';
import 'package:movie_show_watchlist/classes/media.dart';
import 'package:movie_show_watchlist/classes/custom_widgets.dart';

class ItemScreen extends StatefulWidget {

  final AppModel model;
  final Media? media;
  final Function(int)? onTabChange;
  const ItemScreen({super.key, required this.model, this.media, this.onTabChange});

  @override
  State<ItemScreen> createState() => _ItemScreen();
}

class _ItemScreen extends State<ItemScreen> {
  late TextEditingController titleController;
  late TextEditingController directorsController;
  late Status selectedStatus;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.media?.title ?? '');

    directorsController = TextEditingController(
      text: widget.media?.directors?.join(', ') ?? '',
    );

    selectedStatus = widget.media?.status ?? Status.notWatched;
  }

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
        appBar: AppBar(title: const Text('My Watch List')),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Center(
                child: Text(
                  "Media Details",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 200),
              Center(
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
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Watch List')),
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
                      "Media Details",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),

                  Center(
                    child: SizedBox(
                      width: 190,
                      height: 260,
                      child: MediaCard(mediaItem: media),
                    ),
                  ),
                  const SizedBox(height: 24),

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
                    decoration: const InputDecoration(
                      labelText: 'Director(s)',
                      hintText: 'Example: Christopher Nolan, James Gunn',
                      border: OutlineInputBorder(),
                    ),
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

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          media.title = titleController.text.trim();

                          media.directors = directorsController.text
                              .split(',')
                              .map((director) => director.trim())
                              .where((director) => director.isNotEmpty)
                              .toList();

                          media.status = selectedStatus;
                          widget.model.selectMedia(null);
                          widget.onTabChange?.call(0);
                        }
                      },
                      child: const Text('Save Changes'),
                    ),
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
          )
      ),
    );
  }
}