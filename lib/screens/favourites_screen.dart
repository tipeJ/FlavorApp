import 'package:FlavorApp/main.dart';
import 'package:FlavorApp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FavouriteFlavorsProvider>(
        builder: (_, provider, child) => provider.getSavedFlavors().isEmpty
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                    Icon(Icons.bookmark_border, size: 52.0),
                    Text("No Favourites Yet.")
                  ]))
            : Scrollbar(
                child: CustomScrollView(slivers: [
                  SliverSafeArea(
                      sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (_, i) => FlavorCard(
                            flavor: provider.getSavedFlavors()[i], index: i),
                        childCount: provider.getSavedFlavors().length),
                  ))
                ]),
              ),
      ),
    );
  }
}
