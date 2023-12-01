import 'package:FlavorApp/models/models.dart';
import 'package:FlavorApp/resources/flavors.dart';
import 'package:FlavorApp/resources/preferences.dart';
import 'package:FlavorApp/screens/favourites_screen.dart';
import 'package:FlavorApp/screens/flavor_screen.dart';
import 'package:FlavorApp/screens/mainlist.dart';
import 'package:FlavorApp/screens/screens.dart';
import 'package:FlavorApp/widgets/loading_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class FavouriteFlavorsProvider extends ChangeNotifier {
  static FlavorRepository _repository = FlavorRepository();
  late Box _favouritesBox;

  Future<FavouriteFlavorsProvider> initialize() async {
    _favouritesBox = await Hive.openBox("favouriteFlavors");
    await FlavorRepository().initialize();
    return this;
  }

  /// Save flavor to favourites Box.
  void saveFlavor(int id) {
    _favouritesBox.add(id);
    notifyListeners();
  }

  /// delete flavor from the favourites Box.
  void unsaveFlavor(int id) {
    for (var i = 0; i < _favouritesBox.length; i++) {
      if (_favouritesBox.getAt(i) == id) {
        _favouritesBox.deleteAt(i);
        continue;
      }
    }
    notifyListeners();
  }

  /// Checks wheteher the flavor exists in the favourites database.
  bool isSaved(int id) {
    for (var i = 0; i < _favouritesBox.length; i++) {
      if (_favouritesBox.getAt(i) == id) return true;
    }
    return false;
  }

  /// Gets all of the flavors from the favourites Box.
  List<Flavor> getSavedFlavors() =>
      _repository.getFlavorsByIds(List<int>.from(_favouritesBox.values));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PreferencesProvider>(
        future: PreferencesProvider().initialize(),
        builder: (context, snapshot) => snapshot.hasData
            ? ChangeNotifierProvider.value(
                value: snapshot.data,
                builder: (context, child) => Consumer<PreferencesProvider>(
                        builder: (context, provider, child) {
                      var brightness;
                      switch (provider.theme) {
                        case PREFS_THEME_DARK:
                          brightness = Brightness.dark;
                          break;
                        case PREFS_THEME_LIGHT:
                          brightness = Brightness.light;
                          break;
                        default:
                          brightness = SchedulerBinding
                                  .instance.window.platformBrightness ??
                              Brightness.light;
                          break;
                      }
                      return MaterialApp(
                          debugShowCheckedModeBanner: false,
                          theme: ThemeData(brightness: brightness),
                          home: FutureBuilder<FavouriteFlavorsProvider>(
                              future: FavouriteFlavorsProvider().initialize(),
                              builder: (context, snapshot) => snapshot.hasData
                                  ? ChangeNotifierProvider.value(
                                      value: snapshot.data,
                                      builder: (context, child) =>
                                          _BottomAppBarWrapper())
                                  : const Center(child: FlavorLauncher())));
                    }))
            // Empty container as a placeholder
            : Container());
  }
}

/// The main navigation bar of the app
class _BottomAppBarWrapper extends StatefulWidget {
  _BottomAppBarWrapper({Key? key}) : super(key: key);

  @override
  __BottomAppBarWrapperState createState() => __BottomAppBarWrapperState();
}

class __BottomAppBarWrapperState extends State<_BottomAppBarWrapper> {
  int _currentPage = 1;

  final _flavorsListScreen = GlobalKey<NavigatorState>();
  final _savedFlavorsListScreen = GlobalKey<NavigatorState>();

  Future<bool> _didPopRoute() async {
    if (_currentPage == 1) {
      _flavorsListScreen.currentState?.maybePop();
    } else if (_currentPage == 0) {
      _savedFlavorsListScreen.currentState?.maybePop();
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _didPopRoute,
        child: Scaffold(
          body: IndexedStack(
            index: _currentPage,
            children: [
              Navigator(
                onGenerateRoute: RouteGenerator.generateR,
                key: _savedFlavorsListScreen,
                initialRoute: 'SavedList',
              ),
              Navigator(
                onGenerateRoute: RouteGenerator.generateR,
                key: _flavorsListScreen,
                initialRoute: 'MainList',
              ),
              PreferencesScreen()
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentPage,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.collections_bookmark), label: "Favourites"),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: "Flavors"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Settings")
            ],
            onTap: (i) {
              if (i == _currentPage && i == 0) {
                _savedFlavorsListScreen.currentState
                    ?.popUntil((route) => route.isFirst);
              } else if (i == _currentPage && i == 1) {
                _flavorsListScreen.currentState?.maybePop();
              } else {
                setState(() {
                  _currentPage = i;
                });
              }
            },
          ),
        ));
  }
}

class RouteGenerator {
  static Route<dynamic> generateR(RouteSettings settings) {
    switch (settings.name) {
      case 'FlavorScreen':
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) =>
                FlavorScreen(flavor: args['flavor'], index: args['index']));
        break;
      case 'MainList':
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                  create: (context) => FlavorListProvider(),
                  builder: (context, child) => FlavorList(),
                ));
      case 'SavedList':
        return MaterialPageRoute(builder: (_) => FavouritesScreen());
      default:
        return MaterialPageRoute(
            builder: (_) =>
                Material(child: Text("No Route Defined for ${settings.name}")));
    }
  }
}
