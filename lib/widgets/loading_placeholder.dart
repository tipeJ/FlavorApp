import 'package:flutter/material.dart';

class LoadingFlavorPlaceholder extends StatelessWidget {
  const LoadingFlavorPlaceholder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Image(image: AssetImage("assets/flavorapp.png")));
  }
}

class FlavorLauncher extends StatefulWidget {
  const FlavorLauncher({Key key}) : super(key: key);

  @override
  _FlavorLauncherState createState() => _FlavorLauncherState();
}

class _FlavorLauncherState extends State<FlavorLauncher>
    with SingleTickerProviderStateMixin {
  var _anv = 0.0; // Animation value
  static const _duration = Duration(milliseconds: 400); // Animation duration

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          _anv = 1.0;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
        child: AnimatedOpacity(
          duration: _duration,
          curve: Curves.easeOut,
          opacity: _anv,
          child: LoadingFlavorPlaceholder()
        ));
  }
}
