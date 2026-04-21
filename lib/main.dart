import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/pages/item_screen.dart';
import 'package:window_manager/window_manager.dart';
import 'package:movie_show_watchlist/pages/item_screen.dart';
// Pages
import 'package:movie_show_watchlist/pages/home_screen.dart';

// Theme
import 'package:movie_show_watchlist/classes/themes.dart';

const Size phoneScreenSize = Size(402, 874);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: phoneScreenSize,
    minimumSize: phoneScreenSize,
    maximumSize: phoneScreenSize,
    center: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Watch List',
      theme: defaultDarkTheme(),
      home: ItemScreen(),
    );
  }
}
