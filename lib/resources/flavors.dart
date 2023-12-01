import 'dart:convert';

import 'package:FlavorApp/models/flavor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';

class FlavorRepository {
  static final FlavorRepository _singleton = FlavorRepository._internal();
  late Box _savedRepo;

  factory FlavorRepository() {
    return _singleton;
  }

  FlavorRepository._internal();

  late List<Flavor> _flavors;

  Future<bool> initialize() async {
    _savedRepo = await Hive.openBox("savedFlavors");
    final data = await rootBundle.loadString("assets/flavordata.json");
    _flavors = await compute(_parseFlavors, data);
    return true;
  }

  List<Flavor> getAllFlavors() => _flavors;

  List<Flavor> getAllSavedFlavors() {
    final saved = getSavedFlavorsIDs();
    print(saved.toString());
    return _flavors.where((fl) => saved.contains(fl.id)).toList();
  }

  Future<List<Flavor>> filterFlavors(String query) {
    List<Flavor> allFlavors = _flavors;
    return compute(_filterFlavors, {'flavors': allFlavors, 'query': query});
  }

  List<Flavor> getFlavorsByIds(List<int> ids) =>
      ids.map<Flavor>((i) => _flavors[i]).toList();

  List<int> getSavedFlavorsIDs() {
    return _savedRepo.values.toList().cast<int>();
  }

  Flavor getFlavor(int id) => _flavors[id];
}

List<Flavor> _parseFlavors(String jsonString) {
  final List<Flavor> list = [];
  final data = json.decode(jsonString);
  data['Ingredients']
      .forEach((ingredient) => list.add(Flavor.fromJson(ingredient)));
  return list;
}

List<Flavor> _filterFlavors(Map<String, dynamic> args) {
  List<Flavor> flavors = args['flavors'];
  String query = args['query'];
  return flavors
      .where(
          (element) => element.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
}
