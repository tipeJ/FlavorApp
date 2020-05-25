import 'package:FlavorApp/models/flavor.dart';
import 'package:FlavorApp/resources/flavors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlavorListProvider extends ChangeNotifier {
  static FlavorRepository _repository = FlavorRepository();

  List<Flavor> flavors = _repository.getAllFlavors();
}

class FlavorList extends StatelessWidget {
  const FlavorList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FlavorListProvider>(
      builder: (_, provider, child) => provider.flavors == null ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: provider.flavors.length,
        itemBuilder: (_, i) => Text(provider.flavors[i].name),
      ),
    );
  }
}