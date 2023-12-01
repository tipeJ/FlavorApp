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

  const FlavorScreen({required this.flavor, required this.index, Key? key})
      : super(key: key);

  @override
  _FlavorScreenState createState() => _FlavorScreenState();

  static Color getFlavorColor(int recommendedValue, BuildContext context) {
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

enum _FlavorsSortType { Rating, Alphabetical, None }

class _FlavorScreenState extends State<FlavorScreen> {
  static const _edgePadding = EdgeInsets.symmetric(horizontal: 16.0);
  static const _listItemPadding = const EdgeInsets.all(5.0);

  late Map<String, int> _flavors;

  late _FlavorsSortType _sortType;

  late bool _saved;

  @override
  void initState() {
    _flavors = widget.flavor.ingredients ?? {};
    // Fetch the default sort type from preferences.
    if (!(_flavors.values.any((t) => t > 0))) {
      _sortType = _FlavorsSortType.None;
    } else if (Provider.of<PreferencesProvider>(context, listen: false)
        .sortByAlpha) {
      _sortType = _FlavorsSortType.Alphabetical;
      _sortByAlpha();
    } else {
      _sortType = _FlavorsSortType.Rating;
    }
    super.initState();
  }

  void _toggleSortFlavors() {
    if (_sortType == _FlavorsSortType.Alphabetical) {
      _flavors = widget.flavor.ingredients ?? {};
      _sortType = _FlavorsSortType.Rating;
    } else if (_sortType != _FlavorsSortType.None) {
      _sortByAlpha();
    }
  }

  /// Sort the flavors alphabetically;
  void _sortByAlpha() {
    final List<String> newList = _flavors.keys.toList()..sort();
    _flavors = {};
    newList.forEach((key) => _flavors[key] = widget.flavor.ingredients[key]!);
    _sortType = _FlavorsSortType.Alphabetical;
  }

  @override
  Widget build(BuildContext context) {
    _saved = Provider.of<FavouriteFlavorsProvider>(context, listen: false)
        .isSaved(widget.flavor.id);
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: false,
          title: Hero(
              tag: Key("FlavorCardScreen: ${widget.index}"),
              child: Text(widget.flavor.name,
                  style: Theme.of(context).primaryTextTheme.headline6)),
          actions: [
            IconButton(
                icon: Icon(_saved ? Icons.bookmark : Icons.bookmark_border),
                tooltip:
                    _saved ? "Remove from Favourites" : "Add to Favourites",
                onPressed: () {
                  if (_saved) {
                    Provider.of<FavouriteFlavorsProvider>(context,
                            listen: false)
                        .unsaveFlavor(widget.flavor.id);
                  } else {
                    Provider.of<FavouriteFlavorsProvider>(context,
                            listen: false)
                        .saveFlavor(widget.flavor.id);
                  }
                  setState(() {
                    _saved = !_saved;
                  });
                })
          ],
        ),
        widget.flavor.season.isNotEmpty ||
                widget.flavor.taste.isNotEmpty ||
                widget.flavor.weight.isNotEmpty ||
                widget.flavor.volume.isNotEmpty
            ? SliverToBoxAdapter(
                child: Container(
                  height: 75.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      widget.flavor.season.isNotEmpty
                          ? SeasonDescription(widget.flavor.season)
                          : null,
                      widget.flavor.taste.isNotEmpty
                          ? TasteDescription(widget.flavor.taste)
                          : null,
                      widget.flavor.weight.isNotEmpty
                          ? WeightDescription(widget.flavor.weight)
                          : null,
                      widget.flavor.volume.isNotEmpty
                          ? VolumeDescription(widget.flavor.volume)
                          : null,
                    ].nonNulls() as List<Widget>,
                  ),
                ),
              )
            : const SliverToBoxAdapter(child: SizedBox()),
        SliverPadding(
            padding: _edgePadding,
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              widget.flavor.function.isNotEmpty
                  ? Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "Function: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: widget.flavor.function)
                    ]))
                  : const SizedBox(),
              widget.flavor.tips.isNotEmpty
                  ? Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "Tips: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: widget.flavor.tips)
                    ]))
                  : const SizedBox(),
            ]))),
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
                        _sortType != _FlavorsSortType.None
                            ? Material(
                                child: IconButton(
                                icon: Icon(_sortType == _FlavorsSortType.Rating
                                    ? Icons.sort
                                    : Icons.sort_by_alpha),
                                tooltip: _sortType == _FlavorsSortType.Rating
                                    ? "Sort Alphabetically"
                                    : "Sort by Rating",
                                onPressed: () {
                                  setState(() {
                                    _toggleSortFlavors();
                                  });
                                },
                              ))
                            : Container()
                      ]),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Container(
                        padding: _listItemPadding,
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    color: FlavorScreen.getFlavorColor(
                                        _flavors.values.elementAt(i), context),
                                    width: 5.0))),
                        child: Text(_flavors.keys.elementAt(i))),
                    childCount: _flavors.length,
                  ),
                ),
              )
            : const SliverToBoxAdapter(child: SizedBox()),
        widget.flavor.flavorAffinities != null &&
                widget.flavor.flavorAffinities.isNotEmpty
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
                        padding: _listItemPadding
                            .add(const EdgeInsets.only(left: 5.0)),
                        child: Text(widget.flavor.flavorAffinities[i])),
                    childCount: widget.flavor.flavorAffinities.length,
                  ),
                ),
              )
            : const SliverToBoxAdapter(child: SizedBox()),
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
                        padding: _listItemPadding
                            .add(const EdgeInsets.only(left: 5.0)),
                        child: Text(widget.flavor.avoid[i])),
                    childCount: widget.flavor.avoid.length,
                  ),
                ),
              )
            : const SliverToBoxAdapter(child: SizedBox()),
      ],
    ));
  }
}
