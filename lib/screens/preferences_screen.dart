import 'package:FlavorApp/resources/preferences.dart';
import 'package:FlavorApp/screens/help_screen.dart';
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
                  onChanged: (newValue) =>
                      provider.putSetting(PREFS_DARK_MODE, newValue)),
              onTap: () =>
                  provider.putSetting(PREFS_DARK_MODE, !provider.darkMode),
            ),
            ListTile(
              title: const Text("Default Sort"),
              subtitle: Text(provider.sortByAlpha ? "Alphabetical" : "Rating"),
              trailing: IconButton(
                  icon: Icon(
                      provider.sortByAlpha ? Icons.sort_by_alpha : Icons.sort),
                  onPressed: () {
                    provider.putSetting(
                        PREFS_DEFAULT_SORT_ALPHA, !provider.sortByAlpha);
                  }),
              onTap: () => provider.putSetting(
                  PREFS_DEFAULT_SORT_ALPHA, !provider.sortByAlpha),
            ),
            ListTile(
                title: const Text("Help"),
                subtitle: const Text("How to use the flavor list"),
                trailing: IconButton(
                    icon: const Icon(Icons.help),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (c) => HelpScreen()));
                    }),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) => HelpScreen())))
          ],
        ),
      ),
    );
  }
}
