import 'package:FlavorApp/models/models.dart';
import 'package:FlavorApp/screens/screens.dart';
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
  Map<String, int> _flavors;

  _FlavorsSortType _sortType;

  bool _saved;

  @override
  void initState() {
    _saved = widget.flavor.saved;
    _sortType = _FlavorsSortType.Rating;
    _flavors = widget.flavor.ingredients;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  setState(() {
                    _saved = !_saved;
                  });
                  FlavorRepository().toggleSaveFlavor(widget.flavor.id);
                }
              )
            ],
          ),
          widget.flavor.season.isNotEmpty || widget.flavor.taste.isNotEmpty || widget.flavor.weight.isNotEmpty || widget.flavor.volume.isNotEmpty
            ? SliverToBoxAdapter(
                child: Container(
                  height: 75.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          SliverList(delegate: SliverChildListDelegate([
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
          ].nonNulls())),
          widget.flavor.ingredients.isNotEmpty
            ? SliverStickyHeader(
                header: Container(
                  height: 60.0,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).canvasColor,
                  child: Text(
                    "Recommended Flavors",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: FlavorScreen._getFlavorColor(widget.flavor.ingredients.values.elementAt(i), context), width: 5.0)
                            )
                          ),
                          child: Text(widget.flavor.ingredients.keys.elementAt(i))
                        ),
                    childCount: widget.flavor.ingredients.length,
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
                  child: const Text(
                    "Flavors to avoid",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Container(
                          padding: const EdgeInsets.all(5.0),
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