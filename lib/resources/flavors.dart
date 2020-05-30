import 'dart:convert';

import 'package:FlavorApp/models/flavor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

class FlavorRepository {
  static final FlavorRepository _singleton = FlavorRepository._internal();

  factory FlavorRepository() {
    return _singleton;
  }

  FlavorRepository._internal();

  List<Flavor> _flavors;

  Future<bool> initialize() async {
    final data = await rootBundle.loadString("assets/flavordata.json");
    _flavors = await compute(_parseFlavors, data);
    return true;
  }

  List<Flavor> getAllFlavors() => _flavors;

  Future<List<Flavor>> filterFlavors(String query) {
    return compute(_filterFlavors, {
      'flavors' : _flavors,
      'query'   : query
    });
  }

  Flavor getFlavor(int id) => _flavors[id];
}

List<Flavor> _parseFlavors(String jsonString){
  final List<Flavor> list = [];
  final data = json.decode(jsonString);
  data['Ingredients'].forEach((ingredient) => list.add(Flavor.fromJson(ingredient)));
  return list;
}

List<Flavor> _filterFlavors(Map<String, dynamic> args) {
  List<Flavor> flavors = args['flavors'];
  String query = args['query'];
  return flavors.where((element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();
}