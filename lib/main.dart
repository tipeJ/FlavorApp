import 'package:FlavorApp/resources/flavors.dart';
import 'package:FlavorApp/screens/flavor_screen.dart';
import 'package:FlavorApp/screens/mainlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
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
      home: _createApp(),
    );
  }
}

Widget _createApp() => FutureBuilder(
  future: FlavorRepository().initialize(),
  builder: (context, snapshot) {
    if(snapshot.connectionState == ConnectionState.done) {
      return Navigator(
        onGenerateRoute: RouteGenerator.generateR,
        initialRoute: 'MainList',
      );
    }
    return const Center(child: CircularProgressIndicator());
  },
);

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
      default:
        return MaterialPageRoute(builder: (_) => Material(child: Text("No Route Defined for ${settings.name}")));
    }
  }
}