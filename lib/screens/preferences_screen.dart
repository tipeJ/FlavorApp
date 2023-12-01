import 'package:FlavorApp/resources/preferences.dart';
import 'package:FlavorApp/screens/help_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PreferencesProvider>(
        builder: (context, provider, child) => ListView(
          children: [
            ListTile(
                title: const Text("Theme"),
                subtitle:
                    const Text("The brightness theme used by this application"),
                trailing: DropdownButton<int>(
                  value: provider.theme,
                  items: const [
                    PREFS_THEME_AUTO,
                    PREFS_THEME_LIGHT,
                    PREFS_THEME_DARK
                  ]
                      .map<DropdownMenuItem<int>>((int value) =>
                          DropdownMenuItem<int>(
                              value: value,
                              child: Text(
                                  const ["Automatic", "Dark", "Light"][value])))
                      .toList(),
                  onChanged: (int? value) =>
                      provider.putSetting(PREFS_THEME, value),
                ),
                onTap: () =>
                    provider.putSetting(PREFS_THEME, (provider.theme + 1) % 3)),
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
