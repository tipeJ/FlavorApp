import 'package:FlavorApp/models/models.dart';
import 'package:flutter/material.dart';

class FlavorCard extends StatelessWidget {
  final Flavor flavor;
  final int index;

  const FlavorCard({@required this.flavor, @required this.index, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed('FlavorScreen', arguments: {
          'flavor' : flavor,
          'index' : index
        }),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                flavor.name,
                style: Theme.of(context).textTheme.headline6,
              )
            ],
          )
        )
      ),
    );
  }
}