import 'dart:convert';

import 'package:FlavorApp/models/flavor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';

class FlavorRepository {
  static final FlavorRepository _singleton = FlavorRepository._internal();
  Box _savedRepo;

  factory FlavorRepository() {
    return _singleton;
  }

  FlavorRepository._internal();

  List<Flavor> _flavors;

  Future<bool> initialize() async {
    Hive.init('FlutterDB');
    _savedRepo = await Hive.openBox("savedFlavors");
    final data = await rootBundle.loadString("assets/flavordata.json");
    _flavors = await compute(_parseFlavors, {
      'jsonString' : data,
      'savedIDs' : getSavedFlavorsIDs()
    });
    return true;
  }

  List<Flavor> getAllFlavors() => _flavors;

  List<Flavor> getAllSavedFlavors() {
    final saved = getSavedFlavorsIDs();
    print(saved.toString());
    return _flavors.where((fl) => saved.contains(fl.id)).toList();
  }

  Future<List<Flavor>> filterFlavors(String query, bool filterUnSaved) {
    List<Flavor> allFlavors = _flavors;
    if (filterUnSaved) allFlavors = getAllSavedFlavors();
    return compute(_filterFlavors, {
      'flavors' : allFlavors,
      'query'   : query
    });
  }

  List<int> getSavedFlavorsIDs() {
    return _savedRepo.values.toList().cast<int>();
  }

  void _saveFlavor(int id) {
    _savedRepo.add(id);
    _flavors[id].saved = true;
  }

  void _unsaveFlavor(int id) {
    for (var i = 0; i < _savedRepo.length; i++) {
      if (_savedRepo.getAt(i) == id) {
        _savedRepo.deleteAt(i);
        _flavors[id].saved = false;
        return;
      }
    }
  }

  void toggleSaveFlavor(int id) {
    if (_flavors[id].saved) {
      _unsaveFlavor(id);
    } else {
      _saveFlavor(id);
    }
  }

  Flavor getFlavor(int id) => _flavors[id];
}

List<Flavor> _parseFlavors(Map<String, dynamic> args){
  final String jsonString = args['jsonString'];
  final List<int> saved = args['savedIDs'];
  final List<Flavor> list = [];
  final data = json.decode(jsonString);
  data['Ingredients'].forEach((ingredient) => list.add(Flavor.fromJson(ingredient, saved.contains(ingredient['ID']))));
  return list;
}

List<Flavor> _filterFlavors(Map<String, dynamic> args) {
  List<Flavor> flavors = args['flavors'];
  String query = args['query'];
  return flavors.where((element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();
}