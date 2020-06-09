import 'package:FlavorApp/main.dart';
import 'package:FlavorApp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FavouriteFlavorsProvider>(
        builder: (_, provider, child) => Scrollbar(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => FlavorCard(flavor: provider.getSavedFlavors()[i], index: i),
                  childCount: provider.getSavedFlavors().length
                ),
              )
            ]
          )
        )
      )
    );
  }
}