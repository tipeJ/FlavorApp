import 'package:FlavorApp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:FlavorApp/resources/resources.dart';

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
  _FlavorsSortType _sortType;
  Map<String, int> _flavors;

  @override
  void initState() {
    _sortType = _FlavorsSortType.Rating;
    _flavors = widget.flavor.ingredients;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: Key("FlavorCardScreen: ${widget.index}"),
          child: Text(
            widget.flavor.name,
            style: Theme.of(context).primaryTextTheme.headline6
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(delegate: SliverChildListDelegate([
            Text(widget.flavor.season),
            Text(widget.flavor.taste),
            Text(widget.flavor.weight),
            Text(widget.flavor.volume),
          ])),
          SliverStickyHeader(
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
          ),
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