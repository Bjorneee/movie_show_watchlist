# Movie/Show Watchlist

Mobile media watchlist developed for CMPE-137 Spring 2026 class final project.

## Developed By
- Anh Khoi Pham
- Benicio Marenco
- Hoang Nhat Ho
- Matt Joshua Saquiton

## App Features
- Manually enter details of movies/shows you want to watch
- View your list of entries to keep track of what you still need to watch
- Mark entries as watched/watching/dropped for better organization
- Give a rating to movies/shows that you watch

## Project Structure

```
movie_show_watchlist
├── lib/           
|   ├── classes/              
|       ├── custom_widgets.dart        # UI components (buttons, cards,..) 
|       ├── media.dart                 # Media structure, fields, helpers
|       ├── model.dart                 # Model logic
|       └── themes.dart                # Theme setup
|   ├── pages
|       ├── add_screen.dart            # Screen for adding new item
|       ├── home_screen.dart           # Display homepage
|       └── item_screen.dart           # Display movie / TV show in detals
|   └── main.dart
├── pubspec.yaml                       # Define dependencies, assets, and project settings
├── ...                                # Other files
└── README.md                          # Overiew and instructions
```