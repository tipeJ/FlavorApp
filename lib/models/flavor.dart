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

  const Flavor({
    this.id,
    this.name,
    this.season,
    this.taste,
    this.weight,
    this.volume,
    this.function,
    this.tips,
    this.techniques,
    this.ingredients,
    this.flavorAffinities,
    this.avoid
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
      tips: json['Tips'],
      techniques: json['Techniques'],
      avoid: json['Avoid'],
      ingredients: Map<String, int>.from(json['Ingredients']),
      flavorAffinities: json['FlavorAffinities']
    );
  }
}