import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

class _AttributeDescription extends StatelessWidget {
  final String title;
  final String content;

  const _AttributeDescription(this.title, this.content, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(title,
              textScaleFactor: 1.5,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(content)
        ]));
  }
}

class SeasonDescription extends StatelessWidget {
  final String season;
  const SeasonDescription(this.season, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _AttributeDescription("Season", season);
}

class TasteDescription extends StatelessWidget {
  final String taste;
  const TasteDescription(this.taste, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _AttributeDescription("Taste", taste);
}

class WeightDescription extends StatelessWidget {
  final String weight;
  const WeightDescription(this.weight, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _AttributeDescription("Weight", weight);
}

class VolumeDescription extends StatelessWidget {
  final String volume;
  const VolumeDescription(this.volume, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _AttributeDescription("Volume", volume);
}
