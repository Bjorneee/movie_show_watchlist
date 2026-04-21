import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:window_manager/window_manager.dart';
import 'package:device_preview/device_preview.dart';

// Pages
import 'package:movie_show_watchlist/pages/home_screen.dart';
import 'package:movie_show_watchlist/pages/add_screen.dart';
import 'package:movie_show_watchlist/pages/item_screen.dart';

// Theme
import 'package:movie_show_watchlist/classes/themes.dart';

// App Model
import 'package:movie_show_watchlist/classes/model.dart';

const Size phoneScreenSize = Size(402, 874);
final AppModel userAppModel = AppModel();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //app is crashing during startup before Flutter reaches your runApp due to windowManager
  //Android doesn't support this plugin
  //only run window_manager on desktop (NOT Android / iOS)
  if (!kIsWeb && (Platform.isMacOS || Platform.isLinux || Platform.isWindows)) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
        size: phoneScreenSize,
        minimumSize: phoneScreenSize,
        maximumSize: phoneScreenSize,
        center: true
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }


  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => App(),
    )
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'My Watch List',
      theme: defaultDarkTheme(),
      home: PageHandler(),
    );
  }
}

class PageHandler extends StatefulWidget {
  const PageHandler({super.key});

  @override
  State<PageHandler> createState() => _PageHandler();
}

class _PageHandler extends State<PageHandler> {
  int _currPageIndex = 0;
  int _prevPageIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel> (
      model: userAppModel,
      child: Scaffold(
        extendBody: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            
            Offset begin = (_currPageIndex > _prevPageIndex) 
              ? const Offset(1, 0)
              : const Offset(-1, 0);

            Offset revBegin = (_currPageIndex > _prevPageIndex)
              ? const Offset(-1, 0)
              : const Offset(1, 0);

            bool isIncomingPage = child.key == ValueKey(_currPageIndex);
            if (isIncomingPage) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: begin,
                  end: Offset.zero,
                ).animate(animation),
                child: child
              );
            }
            else {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: revBegin,
                  end: Offset.zero,
                ).animate(animation),
                child: child
              );
            }
          },
          child: IndexedStack(
            key: ValueKey<int>(_currPageIndex),
            index: _currPageIndex,
            children: [

              HomeScreen(model: userAppModel),
              AddScreen(model: userAppModel),
              ItemScreen(model: userAppModel)

            ]
          ),
        ),
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: _currPageIndex,
          onDestinationSelected: (int idx) {
            setState(() {
              _prevPageIndex = _currPageIndex;
              _currPageIndex = idx;
            });
          },
          destinations: const <Widget>[

            NavigationDestination(icon: Icon(Icons.home), label: '', tooltip: '',),
            NavigationDestination(icon: Icon(Icons.add), label: '', tooltip: '',),
            NavigationDestination(icon: Icon(Icons.menu), label: '', tooltip: '',)

          ],
        ),
      )
    );
  }
}