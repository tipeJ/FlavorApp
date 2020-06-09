import 'package:FlavorApp/models/models.dart';
import 'package:FlavorApp/resources/flavors.dart';
import 'package:FlavorApp/screens/favourites_screen.dart';
import 'package:FlavorApp/screens/flavor_screen.dart';
import 'package:FlavorApp/screens/mainlist.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class FavouriteFlavorsProvider extends ChangeNotifier {
  static FlavorRepository _repository = FlavorRepository();
  Box _favouritesBox;

  Future<FavouriteFlavorsProvider> initialize() async {
    Hive.init('FlutterDB');
    _favouritesBox = await Hive.openBox("favouriteFlavors");
    await FlavorRepository().initialize();
    return this;
  }

  void saveFlavor(int id) {
    _favouritesBox.add(id);
    notifyListeners();
  }

  void unsaveFlavor(int id) {
    for (var i = 0; i < _favouritesBox.length; i++) {
      if (_favouritesBox.getAt(i) == id) {
        _favouritesBox.deleteAt(i);
        return;
      }
    }
    notifyListeners();
  }

  bool isSaved(int id) {
    for (var i = 0; i < _favouritesBox.length; i++) {
      if (_favouritesBox.getAt(i) == id) return true;
    }
    return false;
  }

  List<Flavor> getSavedFlavors() => _repository.getFlavorsByIds(List<int>.from(_favouritesBox.values));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlavorApp',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<FavouriteFlavorsProvider>(
          future: FavouriteFlavorsProvider().initialize(),
          builder: (context, snapshot) => snapshot.hasData
            ? ChangeNotifierProvider.value(
                value: snapshot.data,
                builder: (context, child) => _BottomAppBarWrapper()
              )
            : const Center(child: CircularProgressIndicator())
        )
    );
  }
}


class _BottomAppBarWrapper extends StatefulWidget {
  _BottomAppBarWrapper({Key key}) : super(key: key);

  @override
  __BottomAppBarWrapperState createState() => __BottomAppBarWrapperState();
}

class __BottomAppBarWrapperState extends State<_BottomAppBarWrapper> {

  int _currentPage = 1;

  final _flavorsListScreen = GlobalKey<NavigatorState>();
  final _savedFlavorsListScreen = GlobalKey<NavigatorState>();

  Future<bool> _didPopRoute() {
    if (_currentPage == 1) {
      return _flavorsListScreen.currentState.maybePop();
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
            Scaffold(
              appBar: AppBar(title: const Text("Settings")),
              body: Container(color: Colors.red),
            ),
          ],
          
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.collections_bookmark),
              title: Text("Favourites")
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text("Flavors")
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text("Settings")
            )
          ],
          onTap: (i) {
            if (i == _currentPage && i == 1) {
              _flavorsListScreen.currentState.popUntil((route) => route.isFirst);
            } else {
              setState(() {
                _currentPage = i;
              });
            }
          },
        ),
      )
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateR(RouteSettings settings){
    switch (settings.name) {
      case 'FlavorScreen':
        Map<String, dynamic> args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => FlavorScreen(flavor: args['flavor'], index: args['index'])
        );
        break;
      case 'MainList':
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (context) => FlavorListProvider(),
            builder: (context, child) => FlavorList(),
          )
        );
      case 'SavedList':
        return MaterialPageRoute(
          builder: (_) => FavouritesScreen()
        );
      default:
        return MaterialPageRoute(builder: (_) => Material(child: Text("No Route Defined for ${settings.name}")));
    }
  }
}