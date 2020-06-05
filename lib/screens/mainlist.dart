import 'package:FlavorApp/models/flavor.dart';
import 'package:FlavorApp/resources/flavors.dart';
import 'package:FlavorApp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlavorListProvider extends ChangeNotifier {
  bool filterBySaved;
  
  FlavorListProvider({bool filterBySaved = false}) {
    this.filterBySaved = filterBySaved;
    flavors = filterBySaved ? _repository.getAllSavedFlavors() : _repository.getAllFlavors();
  }

  static FlavorRepository _repository = FlavorRepository();
  List<Flavor> flavors;

  void search(String query) async {
    if (query.isEmpty) {
      flavors = filterBySaved ? _repository.getAllSavedFlavors() : _repository.getAllFlavors();
    } else {
      flavors = await _repository.filterFlavors(query, filterBySaved);
    }
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
          : Scrollbar(
              child: CustomScrollView(
                slivers: [
                  FlavorsSearchbar(),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => FlavorCard(flavor: provider.flavors[i], index: i),
                      childCount: provider.flavors.length
                    ),
                  )
                ]
              )
          )
      )
    );
  }
}