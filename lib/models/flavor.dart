class Flavor {
  final int id;
  final String name;

  final String season;
  final String taste;
  final String weight;
  final String volume;
  final String function;
  final String tips;

  final List<dynamic> techniques;
  final List<dynamic> flavorAffinities;
  final List<dynamic> avoid;

  final Map<String, int> ingredients;

  Flavor({
    required this.id,
    required this.name,
    this.season = '',
    this.taste = '',
    this.weight = '',
    this.volume = '',
    this.function = '',
    this.tips = '',
    this.techniques = const [],
    this.ingredients = const {},
    this.flavorAffinities = const [],
    this.avoid = const [],
  });

  factory Flavor.fromJson(dynamic json) {
    return Flavor(
      id: json['ID'],
      name: json['Name'],
      season: json['Season'],
      taste: json['Taste'],
      weight: json['Weight'],
      volume: json['Volume'],
      function: json['Function'],
      tips: json['Tips'] ?? '',
      techniques: json['Techniques'] ?? [],
      avoid: json['Avoid'] ?? [],
      ingredients: Map<String, int>.from(json['Ingredients'] ?? {}),
      flavorAffinities: json['FlavorAffinities'] ?? [],
    );
  }
}
