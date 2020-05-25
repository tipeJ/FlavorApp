class Flavor {
  final String name;

  final String season;
  final String taste;
  final String weight;
  final String volume;
  final String function;

  final List<dynamic> techniques;
  final List<dynamic> flavorAffinities;

  final Map<String, int> ingredients;

  const Flavor({
    this.name,
    this.season,
    this.taste,
    this.weight,
    this.volume,
    this.function,
    this.techniques,
    this.ingredients,
    this.flavorAffinities
  });

  factory Flavor.fromJson(dynamic json) {
    return Flavor(
      name: json['Name'],
      season: json['Season'],
      taste: json['Taste'],
      weight: json['Weight'],
      volume: json['Volume'],
      function: json['Function'],
      techniques: json['Techniques'],
      ingredients: Map<String, int>.from(json['Ingredients']),
      flavorAffinities: json['FlavorAffinities']
    );
  }
}