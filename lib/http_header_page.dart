import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HttpHeaderPage extends StatefulWidget {
  const HttpHeaderPage({super.key});

  @override
  State<HttpHeaderPage> createState() => _HttpHeaderPageState();
}

class _HttpHeaderPageState extends State<HttpHeaderPage> {
  final _inputController = TextEditingController();
  final _outputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_updateOutput);
  }

  void _updateOutput() {
    setState(() {
      final inputText = _inputController.text;
      if (inputText.isNotEmpty) {
        _outputController.text =
            'labels.http_request_header_x_request_id : "$inputText"';
      } else {
        _outputController.text = '';
      }
    });
  }

  void _copyOutput() {
    if (_outputController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _outputController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _inputController.removeListener(_updateOutput);
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HTTP Request Header Generator',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text('Input Text:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            controller: _inputController,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Paste your text here...',
            ),
          ),
          const SizedBox(height: 24),
          const Text('Generated Output:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _outputController,
                  maxLines: 3,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Output will appear here...',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _copyOutput,
                icon: const Icon(Icons.copy),
                tooltip: 'Copy to clipboard',
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
