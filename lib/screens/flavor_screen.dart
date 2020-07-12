import 'package:FlavorApp/main.dart';
import 'package:FlavorApp/models/models.dart';
import 'package:FlavorApp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:FlavorApp/resources/resources.dart';
import 'package:provider/provider.dart';

class FlavorScreen extends StatefulWidget {
  final Flavor flavor;
  final int index;

  const FlavorScreen({@required this.flavor, @required this.index, Key key}) : super(key: key);

  @override
  _FlavorScreenState createState() => _FlavorScreenState();

  static Color _getFlavorColor(int recommendedValue, BuildContext context) {
    switch (recommendedValue) {
      case 3:
        return Colors.green;
      case 2:
        return Colors.teal;
      case 1:
        return Colors.blueAccent;
      default:
        return Theme.of(context).canvasColor;
    }
  }
}

enum _FlavorsSortType {
  Rating,
  Alphabetical
}

class _FlavorScreenState extends State<FlavorScreen> {
  static const _edgePadding = EdgeInsets.symmetric(horizontal: 16.0);
  static const _listItemPadding = const EdgeInsets.all(5.0);
  
  Map<String, int> _flavors;

  _FlavorsSortType _sortType;

  bool _saved;

  @override
  void initState() {
    _flavors = widget.flavor.ingredients;
    // Fetch the default sort type from preferences.
    _sortType = Provider.of<PreferencesProvider>(context, listen: false).sortByAlpha ? _FlavorsSortType.Alphabetical : _FlavorsSortType.Rating;
    if (_sortType == _FlavorsSortType.Alphabetical) _sortByAlpha();
    super.initState();
  }

  void _toggleSortFlavors() {
    if (_sortType == _FlavorsSortType.Alphabetical) {
      _flavors = widget.flavor.ingredients;
      _sortType = _FlavorsSortType.Rating;
    } else {
      _sortByAlpha();
    }
  }

  /// Sort the flavors alphabetically;
  void _sortByAlpha() {
    final List<String> newList = _flavors.keys.toList()..sort();
    _flavors = {};
    newList.forEach((key) => _flavors[key] = widget.flavor.ingredients[key]);
    _sortType = _FlavorsSortType.Alphabetical;
  }

  @override
  Widget build(BuildContext context) {
    _saved = Provider.of<FavouriteFlavorsProvider>(context, listen: false).isSaved(widget.flavor.id);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            title: Hero(
              tag: Key("FlavorCardScreen: ${widget.index}"),
              child: Text(
                widget.flavor.name,
                style: Theme.of(context).primaryTextTheme.headline6
              )
            ),
            actions: [
              IconButton(
                icon: Icon(_saved ? Icons.bookmark : Icons.bookmark_border),
                tooltip: _saved ? "Unsave Flavor" : "Save Flavor",
                onPressed: () {
                  if (_saved) {
                    Provider.of<FavouriteFlavorsProvider>(context, listen: false).unsaveFlavor(widget.flavor.id);
                  } else {
                    Provider.of<FavouriteFlavorsProvider>(context, listen: false).saveFlavor(widget.flavor.id);
                  }
                  setState(() {
                    _saved = !_saved;
                  });
                }
              )
            ],
          ),
          widget.flavor.season.isNotEmpty || widget.flavor.taste.isNotEmpty || widget.flavor.weight.isNotEmpty || widget.flavor.volume.isNotEmpty
            ? SliverToBoxAdapter(
                child: Container(
                  height: 75.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      widget.flavor.season.isNotEmpty ? SeasonDescription(widget.flavor.season) : null,
                      widget.flavor.taste.isNotEmpty ? TasteDescription(widget.flavor.taste) : null,
                      widget.flavor.weight.isNotEmpty ? WeightDescription(widget.flavor.weight) : null,
                      widget.flavor.volume.isNotEmpty ? VolumeDescription(widget.flavor.volume) : null,
                    ].nonNulls(),
                  ),
                ),
              )
            : null,
          SliverPadding(
            padding: _edgePadding,
            sliver: SliverList(delegate: SliverChildListDelegate([
              widget.flavor.function.isNotEmpty
                ? Text.rich(TextSpan(
                  children: [
                    TextSpan(text: "Function: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.flavor.function)
                  ]
                ))
                : null,
              widget.flavor.tips.isNotEmpty
                ? Text.rich(TextSpan(
                  children: [
                    TextSpan(text: "Tips: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.flavor.tips)
                  ]
                ))
                : null,
            ].nonNulls()))
          ),
          widget.flavor.ingredients.isNotEmpty
            ? SliverStickyHeader(
                header: Container(
                  height: 60.0,
                  padding: _edgePadding,
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).canvasColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recommended Flavors",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Material(
                        child: IconButton(
                          icon: Icon(_sortType == _FlavorsSortType.Rating ? Icons.sort : Icons.sort_by_alpha),
                          tooltip: _sortType == _FlavorsSortType.Rating ? "Sort Alphabetically" : "Sort by Rating",
                          onPressed: () {
                            setState(() {
                              _toggleSortFlavors();
                            });
                          },
                        )
                      )
                    ]
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Container(
                          padding: _listItemPadding,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: FlavorScreen._getFlavorColor(_flavors.values.elementAt(i), context), width: 5.0)
                            )
                          ),
                          child: Text(_flavors.keys.elementAt(i))
                        ),
                    childCount: _flavors.length,
                  ),
                ),
              )
            : null,
          widget.flavor.flavorAffinities != null && widget.flavor.flavorAffinities.isNotEmpty
            ? SliverStickyHeader(
                header: Container(
                  height: 60.0,
                  padding: _edgePadding,
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).canvasColor,
                  child: Text(
                    "Affinities",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Container(
                          padding: _listItemPadding,
                          child: Text(widget.flavor.flavorAffinities[i])
                        ),
                    childCount: widget.flavor.flavorAffinities.length,
                  ),
                ),
              )
            : null,
          widget.flavor.avoid != null && widget.flavor.avoid.isNotEmpty
            ? SliverStickyHeader(
                header: Container(
                  height: 60.0,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).canvasColor,
                  child: Text(
                    "Flavors to Avoid",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Container(
                          padding: _listItemPadding,
                          child: Text(widget.flavor.avoid[i])
                        ),
                    childCount: widget.flavor.avoid.length,
                  ),
                ),
              )
            : null
        ].nonNulls(),
      )
    );
  }
}