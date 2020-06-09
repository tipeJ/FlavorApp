import 'package:FlavorApp/resources/preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PreferencesProvider>(
        builder: (context, provider, child) => ListView(
          children: [
            ListTile(
              title: const Text("Dark Mode"),
              subtitle: const Text("Enables Dark Mode for this application"),
              trailing: Switch.adaptive(
                value: provider.darkMode, 
                onChanged: (newValue) => provider.putSetting(PREFS_DARK_MODE, newValue)
              ),
              onTap: () => provider.putSetting(PREFS_DARK_MODE, !provider.darkMode),
            )
          ],
        ),
      ),
    );
  }
}