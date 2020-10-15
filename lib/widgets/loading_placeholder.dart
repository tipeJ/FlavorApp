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
  static const _duration = Duration(milliseconds: 1250); // Animation duration

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
        color: const Color.fromARGB(255, 15, 15, 20),
        child: AnimatedContainer(
            duration: _duration,
            curve: Curves.ease,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(
                top:
                    (MediaQuery.of(context).size.height / 4) * (1 - _anv / 1.5),
                bottom: 0.0,
                left: 100,
                right: 100),
            child: AnimatedOpacity(
                duration: _duration,
                curve: Curves.easeOut,
                opacity: _anv,
                child: const LoadingFlavorPlaceholder())));
  }
}
