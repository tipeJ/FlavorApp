import 'package:FlavorApp/models/flavor.dart';
import 'package:FlavorApp/resources/flavors.dart';
import 'package:FlavorApp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlavorListProvider extends ChangeNotifier {
  FlavorListProvider() {
    flavors = _repository.getAllFlavors();
  }

  static FlavorRepository _repository = FlavorRepository();
  late List<Flavor> flavors;

  void search(String query) async {
    if (query.isEmpty) {
      flavors = _repository.getAllFlavors();
    } else {
      flavors = await _repository.filterFlavors(query);
    }
    notifyListeners();
  }
}

class FlavorList extends StatefulWidget {
  FlavorList({Key? key}) : super(key: key);

  @override
  _FlavorListState createState() => _FlavorListState();
}

class _FlavorListState extends State<FlavorList> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _willPop() {
    if (_controller.offset <= 25.0) {
      return Future.value(true);
    }
    // Do a quick jump 'n animate if the offset is high enough (To avoid loading unnecessary list items)
    if (_controller.offset > 2000) {
      _controller.jumpTo(350.0);
    }
    _controller.animateTo(0.0,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPop,
      child: Scaffold(
        body: Consumer<FlavorListProvider>(
            builder: (_, provider, child) => provider.flavors == null
                ? const Center(child: CircularProgressIndicator())
                : Scrollbar(
                    controller: _controller,
                    child: CustomScrollView(controller: _controller, slivers: [
                      FlavorsSearchbar(),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) =>
                              FlavorCard(flavor: provider.flavors[i], index: i),
                          childCount: provider.flavors.length,
                        ),
                      )
                    ]))),
      ),
    );
  }
}
