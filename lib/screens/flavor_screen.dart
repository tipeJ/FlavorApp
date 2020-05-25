import 'package:FlavorApp/models/models.dart';
import 'package:flutter/material.dart';

class FlavorScreen extends StatelessWidget {
  final Flavor flavor;
  final int index;

  const FlavorScreen({@required this.flavor, @required this.index, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: Key("FlavorCardScreen: $index"),
          child: Text(flavor.name),
        ),
      ),
      body: ListView.builder(
        itemCount: flavor.ingredients.length,
        itemBuilder: (_, i) => Text(flavor.ingredients.keys.elementAt(i)),
      ),
    );
  }
}