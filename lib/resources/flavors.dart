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

  Future<void> initialize() async {
    final data = await rootBundle.loadString("assets/flavordata.json");
    _flavors = await compute(_parseFlavors, data);
  }

  List<Flavor> getAllFlavors() => _flavors;
}

List<Flavor> _parseFlavors(String jsonString){
  final List<Flavor> list = [];
  final data = json.decode(jsonString);
  data['Ingredients'].forEach((ingredient) => list.add(Flavor.fromJson(ingredient)));
  return list;
}