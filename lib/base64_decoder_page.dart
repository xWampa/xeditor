import 'dart:convert';
import 'package:flutter/material.dart';

class Base64DecoderPage extends StatefulWidget {
  const Base64DecoderPage({super.key});

  @override
  State<Base64DecoderPage> createState() => _Base64DecoderPageState();
}

class _Base64DecoderPageState extends State<Base64DecoderPage> {
  final _controller = TextEditingController();
  String _output = '';
  //DEFINIR LO QUE QUIERES QUE SE MUESTRE EN LA PANTALLA
  String? _ipAddress;
  String? _issuer;
  String? _migrated;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_decodeBase64);
  }

  void _decodeBase64() {
    setState(() {
      String inputText = _controller.text;
      _output = '';
      //SI NO SE RECUPERA LO PONES A NULL
      _ipAddress = null;
      _issuer = null;
      _migrated = null;

      if (inputText.isEmpty) {
        return;
      }

      try {
        String sanitizedInput = inputText.replaceAll(RegExp(r'[^A-Za-z0-9+/]'), '');
        int validLength = (sanitizedInput.length ~/ 4) * 4;
        if (validLength == 0) {
          return;
        }
        String decodablePart = sanitizedInput.substring(0, validLength);

        final decodedBytes = base64Decode(decodablePart);
        _output = utf8.decode(decodedBytes, allowMalformed: true);

        // Extract IP address using a regular expression.
        final ipRegex = RegExp(r'"ip":"(.*?)"');
        final matchIpRegex = ipRegex.firstMatch(_output);
        if (matchIpRegex != null) {
          _ipAddress = matchIpRegex.group(1);
        }
        // Extract issuer using a regular expression.
        final issRegex = RegExp(r'"iss":"(.*?)"');
        final matchIssRegex = issRegex.firstMatch(_output);
        if (matchIssRegex != null) {
          _issuer = matchIssRegex.group(1);
        }
        // Extract issuer using a regular expression.
        final migratedRegex = RegExp(r'"m":"(.*?)"');
        final matchMigratedRegex = migratedRegex.firstMatch(_output);
        if (matchMigratedRegex != null) {
          _migrated = matchMigratedRegex.group(1);
        }
      } catch (e) {
        _output = '';
        //SI NO SE RECUPERA LO PONES A NULL
        _ipAddress = null;
        _issuer = null;
        _migrated = null;
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_decodeBase64);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter Base64 String:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'e.g., SGVsbG8gV29ybGQh',
            ),
          ),
          //AQUI COMIENZAN LOS CHIPS ip
          const SizedBox(height: 16),
          if (_ipAddress != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  Chip(
                    avatar: Icon(Icons.account_circle_rounded),
                    label: Text('IP Address: $_ipAddress'),
                    backgroundColor: Color(0xFF0B2C47),
                  ),
                ],
              ),
            ),
          //AQUI COMIENZAN LOS CHIPS iss
          const SizedBox(height: 16),
          if (_issuer != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  Chip(
                    avatar: Icon(Icons.account_circle_rounded),
                    label: Text('Issuer: $_issuer'),
                    backgroundColor: Color(0xFFA8530D),
                  ),
                ],
              ),
            ),
          //AQUI COMIENZAN LOS CHIPS migrated
          const SizedBox(height: 16),
          if (_migrated != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  Chip(
                    avatar: Icon(Icons.account_circle_rounded),
                    label: Text('Migrado: $_migrated'),
                    backgroundColor: Color(0xFF770A0A),
                  ),
                ],
              ),
            ),
          const Text('Decoded Output:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: SelectableText(_output),
            ),
          ),
        ],
      ),
    );
  }
}
