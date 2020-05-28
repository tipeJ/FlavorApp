import 'package:FlavorApp/models/flavor.dart';
import 'package:FlavorApp/resources/flavors.dart';
import 'package:FlavorApp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_floating_app_bar/rounded_floating_app_bar.dart';

class FlavorListProvider extends ChangeNotifier {
  static FlavorRepository _repository = FlavorRepository();

  List<Flavor> flavors = _repository.getAllFlavors();

  void search(String query) async {
    flavors = await _repository.filterFlavors(query);
    notifyListeners();
  }
}

class FlavorList extends StatelessWidget {
  const FlavorList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FlavorListProvider>(
        builder: (_, provider, child) => provider.flavors == null 
          ? const Center(child: CircularProgressIndicator()) 
          : CustomScrollView(
            slivers: [
              RoundedFloatingAppBar(
                title: TextField(
                  decoration: InputDecoration.collapsed(
                    hintText: "Search"
                  ),
                  onChanged: (str) => provider.search(str),
                ),
                floating: true,
                snap: true,
                elevation: 5.0,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => FlavorCard(flavor: provider.flavors[i], index: i),
                  childCount: provider.flavors.length
                ),
              )
            ]
          )
      )
    );
  }
}