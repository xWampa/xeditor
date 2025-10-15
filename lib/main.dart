import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/json.dart';
import 'package:xeditor/settings_page.dart';
import 'package:xeditor/base64_decoder_page.dart';
import 'package:clipboard/clipboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Editor',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _urlController = TextEditingController(
      text:
          'https://test-sd.cdn.sve.video.telefonicaservices.com/VoD/vod.svc/phone.android/environments/pre69/ws-directory');
  String? _error;
  Map<String, TextStyle> _currentTheme = monokaiSublimeTheme;

  late final CodeController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: '{\n  "key": "value"\n}',
      language: json,
    );
  }

  void _onThemeChanged(Map<String, TextStyle> theme) {
    setState(() {
      _currentTheme = theme;
    });
  }

  void _validateJson() {
    try {
      jsonDecode(_codeController.text);
      setState(() {
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  void _formatJson() {
    try {
      final decoded = jsonDecode(_codeController.text);
      final prettyJson = const JsonEncoder.withIndent('  ').convert(decoded);
      setState(() {
        _codeController.text = prettyJson;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  void _loadJsonFromUrl() async {
    final url = _urlController.text;
    if (url.isEmpty) {
      return;
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final prettyJson = const JsonEncoder.withIndent('  ').convert(decoded);
        setState(() {
          _codeController.text = prettyJson;
          _error = null;
        });
      } else {
        setState(() {
          _error = 'Failed to load JSON: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load or parse JSON: $e';
      });
    }
  }

  void _pasteText() async {
    final text = await FlutterClipboard.paste();
    setState(() {
      _codeController.text = text;
      _error = null;
    });
  }

  void _copyText() {
    FlutterClipboard.copy(_codeController.text);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.vpn_key),
                label: Text('Base64'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.edit),
                label: Text('Editor'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                const Base64DecoderPage(),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _urlController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter JSON URL',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _loadJsonFromUrl,
                                child: const Text('Load from URL'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: _pasteText,
                                child: const Text('Paste'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _copyText,
                                child: const Text('Copy'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _validateJson,
                                child: const Text('Validate'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _formatJson,
                                child: const Text('Format'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    CodeTheme(
                      data: CodeThemeData(styles: _currentTheme),
                      child: CodeField(
                        controller: _codeController,
                        lineNumbers: true,
                      ),
                    ),
                  ],
                ),
                SettingsPage(
                  theme: _currentTheme,
                  onThemeChanged: _onThemeChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
