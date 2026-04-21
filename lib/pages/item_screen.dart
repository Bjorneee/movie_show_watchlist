import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/widgets/containers.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreen();
}

class _ItemScreen extends State<ItemScreen> {
  final TextEditingController titleController = TextEditingController(
    text: 'Super Mario Movie',
  );
  final TextEditingController genreController = TextEditingController(
    text: 'Fantasy, Video Game, Adventure, Comedy',
  );
  final TextEditingController directorController = TextEditingController(
    text: 'Michael Jelenic, Aaron Horvath',
  );

  String status = 'Watching';
  int rating = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PosterCard(title: titleController.text),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              DetailFieldBox(
                label: 'Title:',
                child: TextField(
                  controller: titleController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(),
                ),
              ),

              DetailFieldBox(
                label: 'Genre(s):',
                child: TextField(
                  controller: genreController,
                  decoration: const InputDecoration(),
                ),
              ),

              DetailFieldBox(
                label: 'Director:',
                child: TextField(
                  controller: directorController,
                  decoration: const InputDecoration(),
                ),
              ),

              DetailFieldBox(
                label: 'Status:',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButton<String>(
                    value: status,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Watched',
                        child: Text('Watched'),
                      ),
                      DropdownMenuItem(
                        value: 'Watching',
                        child: Text('Watching'),
                      ),
                      DropdownMenuItem(
                        value: 'Dropped',
                        child: Text('Dropped'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        status = value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: PrimaryActionButton(
                      text: 'Save',
                      onPressed: () {
                        debugPrint('Saved: ${titleController.text}');
                        debugPrint('Genre: ${genreController.text}');
                        debugPrint('Director: ${directorController.text}');
                        debugPrint('Status: $status');
                        debugPrint('Rating: $rating');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DangerActionButton(
                      text: 'Remove',
                      onPressed: () {
                        debugPrint('Removed item');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
