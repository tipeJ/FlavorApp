import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class _AttributeIcon extends StatelessWidget {
  final IconData icon;
  final String description;

  const _AttributeIcon(this.icon, this.description, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(icon)
      ),
      Text(description)
    ]);
  }
}

class _AttributeDescription extends StatelessWidget {
  final String title;
  final String content;

  const _AttributeDescription(this.title, this.content, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          title,
          textScaleFactor: 1.5,
          style: const TextStyle(fontWeight: FontWeight.bold)
        )
      ),
      Text(content)
    ]);
  }
}

class SeasonIcon extends StatelessWidget {
  final String season;
  const SeasonIcon(this.season, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _AttributeIcon(FlutterIcons.calendar_faw5, season);
}

class TasteIcon extends StatelessWidget {
  final String taste;
  const TasteIcon(this.taste, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _AttributeIcon(FlutterIcons.wine_glass_faw5s, taste);
}

class WeightIcon extends StatelessWidget {
  final String weight;
  const WeightIcon(this.weight, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _AttributeIcon(FlutterIcons.weight_hanging_faw5s, weight);
}

class VolumeIcon extends StatelessWidget {
  final String volume;
  const VolumeIcon(this.volume, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _AttributeIcon(FlutterIcons.gas_cylinder_mco, volume);
}

class SeasonDescription extends StatelessWidget {
  final String season;
  const SeasonDescription(this.season, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _AttributeDescription("Season", season);
}

class TasteDescription extends StatelessWidget {
  final String taste;
  const TasteDescription(this.taste, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _AttributeDescription("Taste", taste);
}

class WeightDescription extends StatelessWidget {
  final String weight;
  const WeightDescription(this.weight, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _AttributeDescription("Weight", weight);
}

class VolumeDescription extends StatelessWidget {
  final String volume;
  const VolumeDescription(this.volume, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _AttributeDescription("Volume", volume);
}