import 'package:flutter/material.dart';
import 'screens.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key key}) : super(key: key);
  static const _infoTiles = [
    "This is a recommended flavor",
    "This is a frequently recommended flavor",
    "This is a very recommended flavor",
    "This is an extremely recommended flavor"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sample Flavor"),
        actions: [
          Builder(
              builder: (_) => IconButton(
                  icon: const Icon(Icons.bookmark),
                  onPressed: () {
                    Scaffold.of(_).showSnackBar(const SnackBar(
                        content: Text("Flavor added to favourites!")));
                  }))
        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List<Widget>.generate(
              4,
              (i) => Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color: FlavorScreen.getFlavorColor(i, context),
                              width: 5.0))),
                  child: Text(_infoTiles[i]))).reversed.toList()),
    );
  }
}
