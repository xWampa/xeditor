import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/vs2015.dart';

const themes = {
  'monokai-sublime': monokaiSublimeTheme,
  'a11y-dark': a11yDarkTheme,
  'a11y-light': a11yLightTheme,
  'github': githubTheme,
  'vs2015': vs2015Theme,
};

class SettingsPage extends StatefulWidget {
  final Map<String, TextStyle> theme;
  final ValueChanged<Map<String, TextStyle>> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.theme,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = themes.entries
        .firstWhere((entry) => entry.value == widget.theme, orElse: () => themes.entries.first)
        .key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<String>(
              value: _selectedTheme,
              items: themes.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTheme = newValue;
                    widget.onThemeChanged(themes[newValue]!);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
