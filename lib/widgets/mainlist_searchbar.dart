import 'package:FlavorApp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_floating_app_bar/rounded_floating_app_bar.dart';

class FlavorsSearchbar extends StatefulWidget {
  const FlavorsSearchbar({Key key}) : super(key: key);

  @override
  _FlavorsSearchbarState createState() => _FlavorsSearchbarState();
}

class _FlavorsSearchbarState extends State<FlavorsSearchbar> {

  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() { 
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FlavorListProvider>(
        builder: (_, provider, child) => RoundedFloatingAppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration.collapsed(
                    hintText: "Search"
                  ),
                  onChanged: (str) => provider.search(str),
                )
              ),
              Visibility(
                visible: _controller.text.isNotEmpty,
                child: IconButton(
                  icon: const Icon(Icons.close),  
                  onPressed: () {
                    _controller.text = '';
                    provider.search('');
                  },
                ),
              )
            ]
          ),
          floating: true,
          snap: true,
          elevation: 5.0,
        )
    );
  }
}