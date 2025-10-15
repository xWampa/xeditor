import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Base64DecoderPage extends StatefulWidget {
  const Base64DecoderPage({super.key});

  @override
  State<Base64DecoderPage> createState() => _Base64DecoderPageState();
}

enum Calendar { day, week, month, year }

enum MigrationStatus { migrationTrue, migrationFalse }

enum TokenTipo { access, movistar, anonymous }

enum LoginTipo { credentials, autologin, anonymous }

class _Base64DecoderPageState extends State<Base64DecoderPage> {
  final _controller = TextEditingController();
  String _output = '';
  //DEFINIR LO QUE QUIERES QUE SE MUESTRE EN LA PANTALLA
  String? _ipAddress;
  String? _issuer;
  String? _migrated;
  String? _accountId;
  String? _deviceType;
  String? _deviceId;
  String? _openPlatformId;
  String? _profileId;
  String? _maxStreams;
  String? _maxStreamsFueraDeCasa;
  String? _maxPreferenteFueraDeCasa;
  String? _maxNoPreferenteFueraDeCasa;
  String? _cluster;
  String? _enCasa;
  String? _tokenTipo;
  String? _loginTipo;
  Calendar calendarView = Calendar.day;

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
      _accountId = null;
      _deviceType = null;
      _deviceId = null;
      _openPlatformId = null;
      _profileId = null;
      _maxStreams = null;
      _maxStreamsFueraDeCasa = null;
      _maxPreferenteFueraDeCasa = null;
      _maxNoPreferenteFueraDeCasa = null;
      _cluster = null;
      _enCasa = null;
      _tokenTipo = null;
      _loginTipo = null;

      if (inputText.isEmpty) {
        return;
      }

      try {
        String sanitizedInput = inputText.replaceAll(
          RegExp(r'[^A-Za-z0-9+/]'),
          '',
        );
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
        // Extract migrated using a regular expression.
        final migratedRegex = RegExp(r'"m":"(.*?)"');
        final matchMigratedRegex = migratedRegex.firstMatch(_output);
        if (matchMigratedRegex != null) {
          _migrated = matchMigratedRegex.group(1);
        }
        // Extract account ID using a regular expression.
        final accountIdRegex = RegExp(r'"id":"(.*?)"');
        final matchAccountIdRegex = accountIdRegex.firstMatch(_output);
        if (matchAccountIdRegex != null) {
          _accountId = matchAccountIdRegex.group(1);
        }
        // Extract device type using a regular expression.
        final deviceTypeRegex = RegExp(r'"dt":"(.*?)"');
        final matchDeviceTypeRegex = deviceTypeRegex.firstMatch(_output);
        if (matchDeviceTypeRegex != null) {
          _deviceType = matchDeviceTypeRegex.group(1);
        }
        // Extract device ID using a regular expression.
        final deviceIdRegex = RegExp(r'"did":"(.*?)"');
        final matchDeviceIdRegex = deviceIdRegex.firstMatch(_output);
        if (matchDeviceIdRegex != null) {
          _deviceId = matchDeviceIdRegex.group(1);
        }
        // Extract OpenPlatform ID using a regular expression.
        final openPlatformIdRegex = RegExp(r'"sub":"(.*?)"');
        final matchOpenPlatformIdRegex = openPlatformIdRegex.firstMatch(
          _output,
        );
        if (matchOpenPlatformIdRegex != null) {
          _openPlatformId = matchOpenPlatformIdRegex.group(1);
        }
        // Extract Profile ID using a regular expression.
        final profileIdRegex = RegExp(r'"pid":"(.*?)"');
        final matchProfileIdRegex = profileIdRegex.firstMatch(_output);
        if (matchProfileIdRegex != null) {
          _profileId = matchProfileIdRegex.group(1);
        }
        // Extract Max Streams using a regular expression.
        final maxStreamsRegex = RegExp(r'"ms":"(.*?)"');
        final matchMaxStreamsRegex = maxStreamsRegex.firstMatch(_output);
        if (matchMaxStreamsRegex != null) {
          _maxStreams = matchMaxStreamsRegex.group(1);
        }
        // Extract Max Streams Fuera de Casa using a regular expression.
        final maxStreamsFueraDeCasaRegex = RegExp(r'"msou":"(.*?)"');
        final matchMaxStreamsFueraDeCasaRegex = maxStreamsFueraDeCasaRegex
            .firstMatch(_output);
        if (matchMaxStreamsFueraDeCasaRegex != null) {
          _maxStreamsFueraDeCasa = matchMaxStreamsFueraDeCasaRegex.group(1);
        }
        // Extract Max Preferente Fuera de Casa using a regular expression.
        final maxPreferenteFueraDeCasaRegex = RegExp(r'"mpsou":"(.*?)"');
        final matchMaxPreferenteFueraDeCasaRegex = maxPreferenteFueraDeCasaRegex
            .firstMatch(_output);
        if (matchMaxPreferenteFueraDeCasaRegex != null) {
          _maxPreferenteFueraDeCasa = matchMaxPreferenteFueraDeCasaRegex.group(
            1,
          );
        }
        // Extract Max noPreferente Fuera de Casa using a regular expression.
        final maxNoPreferenteFueraDeCasaRegex = RegExp(r'"mnpsou":"(.*?)"');
        final matchMaxNoPreferenteFueraDeCasaRegex =
            maxNoPreferenteFueraDeCasaRegex.firstMatch(_output);
        if (matchMaxNoPreferenteFueraDeCasaRegex != null) {
          _maxNoPreferenteFueraDeCasa = matchMaxNoPreferenteFueraDeCasaRegex
              .group(1);
        }
        // Extract Cluster using a regular expression.
        final clusterRegex = RegExp(r'"cluster":"(.*?)"');
        final matchClusterRegex = clusterRegex.firstMatch(_output);
        if (matchClusterRegex != null) {
          _cluster = matchClusterRegex.group(1);
        }
        // Extract En Casa using a regular expression.
        final enCasaRegex = RegExp(r'"h":"(.*?)"');
        final matchEnCasaRegex = enCasaRegex.firstMatch(_output);
        if (matchEnCasaRegex != null) {
          _enCasa = matchEnCasaRegex.group(1);
        }
        // Extract Token Tipo using a regular expression.
        final tokenTipoRegex = RegExp(r'"tp":"(.*?)"');
        final matchTokenTipoRegex = tokenTipoRegex.firstMatch(_output);
        if (matchTokenTipoRegex != null) {
          _tokenTipo = matchTokenTipoRegex.group(1);
        }
        // Extract Login Tipo using a regular expression.
        final loginTipoRegex = RegExp(r'"lt":"(.*?)"');
        final matchLoginTipoRegex = loginTipoRegex.firstMatch(_output);
        if (matchLoginTipoRegex != null) {
          _loginTipo = matchLoginTipoRegex.group(1);
        }
      } catch (e) {
        _output = '';
        //SI NO SE RECUPERA LO PONES A NULL
        _ipAddress = null;
        _issuer = null;
        _migrated = null;
        _accountId = null;
        _deviceType = null;
        _deviceId = null;
        _openPlatformId = null;
        _profileId = null;
        _maxStreams = null;
        _maxStreamsFueraDeCasa = null;
        _maxPreferenteFueraDeCasa = null;
        _maxNoPreferenteFueraDeCasa = null;
        _cluster = null;
        _enCasa = null;
        _tokenTipo = null;
        _loginTipo = null;
      }
    });
  }

  void _copyIpAddress() {
    if (_ipAddress != null) {
      Clipboard.setData(ClipboardData(text: _ipAddress!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('IP Address copied to clipboard: $_ipAddress'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyIssuer() {
    if (_issuer != null) {
      Clipboard.setData(ClipboardData(text: _issuer!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Issuer copied to clipboard: $_issuer'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyAccountId() {
    if (_accountId != null) {
      Clipboard.setData(ClipboardData(text: _accountId!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account ID copied to clipboard: $_accountId'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyOpenPlatformId() {
    if (_openPlatformId != null) {
      Clipboard.setData(ClipboardData(text: _openPlatformId!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'OpenPlatform ID copied to clipboard: $_openPlatformId',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyDeviceType() {
    if (_deviceType != null) {
      Clipboard.setData(ClipboardData(text: _deviceType!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Device Type copied to clipboard: $_deviceType'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyDeviceId() {
    if (_deviceId != null) {
      Clipboard.setData(ClipboardData(text: _deviceId!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Device ID copied to clipboard: $_deviceId'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyProfileId() {
    if (_profileId != null) {
      Clipboard.setData(ClipboardData(text: _profileId!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile ID copied to clipboard: $_profileId'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyCluster() {
    if (_cluster != null) {
      Clipboard.setData(ClipboardData(text: _cluster!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cluster copied to clipboard: $_cluster'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyMaxStreams() {
    if (_maxStreams != null) {
      Clipboard.setData(ClipboardData(text: _maxStreams!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Max Streams copied to clipboard: $_maxStreams'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyMaxStreamsFueraDeCasa() {
    if (_maxStreamsFueraDeCasa != null) {
      Clipboard.setData(ClipboardData(text: _maxStreamsFueraDeCasa!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Max Streams Fuera de casa copied to clipboard: $_maxStreamsFueraDeCasa',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyMaxPreferenteFueraDeCasa() {
    if (_maxPreferenteFueraDeCasa != null) {
      Clipboard.setData(ClipboardData(text: _maxPreferenteFueraDeCasa!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Max Preferente Fuera de casa copied to clipboard: $_maxPreferenteFueraDeCasa',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyMaxNoPreferenteFueraDeCasa() {
    if (_maxNoPreferenteFueraDeCasa != null) {
      Clipboard.setData(ClipboardData(text: _maxNoPreferenteFueraDeCasa!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Max noPreferente Fuera de casa copied to clipboard: $_maxNoPreferenteFueraDeCasa',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
                  GestureDetector(
                    onTap: _copyIpAddress,
                    child: Chip(
                      avatar: Icon(Icons.podcasts_outlined),
                      label: Text('IP Address: $_ipAddress'),
                      backgroundColor: Color(0xFF0B2C47),
                    ),
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
                  GestureDetector(
                    onTap: _copyIssuer,
                    child: Chip(
                      avatar: Icon(Icons.key),
                      label: Text('Issuer: $_issuer'),
                      backgroundColor: Color(0xFFA8530D),
                    ),
                  ),
                ],
              ),
            ),
          //AQUI COMIENZAN LOS CHIPS Account ID y OpenPlatform ID (same row)
          const SizedBox(height: 16),
          if (_accountId != null || _openPlatformId != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  if (_accountId != null)
                    GestureDetector(
                      onTap: _copyAccountId,
                      child: Chip(
                        avatar: Icon(Icons.account_circle),
                        label: Text('Account ID: $_accountId'),
                        backgroundColor: Color(
                          0xFF2E7D32,
                        ), // Green color for Account ID
                      ),
                    ),
                  if (_openPlatformId != null)
                    GestureDetector(
                      onTap: _copyOpenPlatformId,
                      child: Chip(
                        avatar: Icon(Icons.open_in_new),
                        label: Text('OpenPlatform ID: $_openPlatformId'),
                        backgroundColor: Color.fromARGB(
                          255,
                          0,
                          87,
                          99,
                        ), // Cyan color for OpenPlatform ID
                      ),
                    ),
                ],
              ),
            ),
          //AQUI COMIENZAN LOS CHIPS Device Type y Device ID (same row)
          const SizedBox(height: 16),
          if (_deviceType != null || _deviceId != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  if (_deviceType != null)
                    GestureDetector(
                      onTap: _copyDeviceType,
                      child: Chip(
                        avatar: Icon(Icons.phone_android),
                        label: Text('Device Type: $_deviceType'),
                        backgroundColor: Color(
                          0xFF6A1B9A,
                        ), // Purple color for Device Type
                      ),
                    ),
                  if (_deviceId != null)
                    GestureDetector(
                      onTap: _copyDeviceId,
                      child: Chip(
                        avatar: Icon(Icons.fingerprint),
                        label: Text('Device ID: $_deviceId'),
                        backgroundColor: Color(
                          0xFF795548,
                        ), // Brown color for Device ID
                      ),
                    ),
                ],
              ),
            ),
          //AQUI COMIENZAN LOS CHIPS Profile ID y Cluster (same row)
          const SizedBox(height: 16),
          if (_profileId != null || _cluster != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  if (_profileId != null)
                    GestureDetector(
                      onTap: _copyProfileId,
                      child: Chip(
                        avatar: Icon(Icons.person_outline),
                        label: Text('Profile ID: $_profileId'),
                        backgroundColor: Color(
                          0xFF4527A0,
                        ), // Deep purple color for Profile ID
                      ),
                    ),
                  if (_cluster != null)
                    GestureDetector(
                      onTap: _copyCluster,
                      child: Chip(
                        avatar: Icon(Icons.dns),
                        label: Text('Cluster: $_cluster'),
                        backgroundColor: Color(
                          0xFF37474F,
                        ), // Blue-grey color for Cluster
                      ),
                    ),
                ],
              ),
            ),
          //AQUI COMIENZAN LOS CHIPS STREAMING LIMITS (all in same row)
          const SizedBox(height: 16),
          if (_maxStreams != null ||
              _maxStreamsFueraDeCasa != null ||
              _maxPreferenteFueraDeCasa != null ||
              _maxNoPreferenteFueraDeCasa != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  if (_maxStreams != null)
                    GestureDetector(
                      onTap: _copyMaxStreams,
                      child: Chip(
                        avatar: Icon(Icons.play_circle_outline),
                        label: Text('Max Streams: $_maxStreams'),
                        backgroundColor: Color(
                          0xFF1565C0,
                        ), // Blue color for Max Streams
                      ),
                    ),
                  if (_maxStreamsFueraDeCasa != null)
                    GestureDetector(
                      onTap: _copyMaxStreamsFueraDeCasa,
                      child: Chip(
                        avatar: Icon(Icons.home_work_outlined),
                        label: Text(
                          'Max Streams Fuera de casa: $_maxStreamsFueraDeCasa',
                        ),
                        backgroundColor: Color.fromARGB(
                          255,
                          143,
                          50,
                          0,
                        ), // Orange color for Fuera de casa
                      ),
                    ),
                  if (_maxPreferenteFueraDeCasa != null)
                    GestureDetector(
                      onTap: _copyMaxPreferenteFueraDeCasa,
                      child: Chip(
                        avatar: Icon(Icons.star_outline),
                        label: Text(
                          'Max Preferente Fuera de casa: $_maxPreferenteFueraDeCasa',
                        ),
                        backgroundColor: Color(
                          0xFF2E7D32,
                        ), // Green color for Preferente
                      ),
                    ),
                  if (_maxNoPreferenteFueraDeCasa != null)
                    GestureDetector(
                      onTap: _copyMaxNoPreferenteFueraDeCasa,
                      child: Chip(
                        avatar: Icon(Icons.star_border),
                        label: Text(
                          'Max noPreferente Fuera de casa: $_maxNoPreferenteFueraDeCasa',
                        ),
                        backgroundColor: Color(
                          0xFF8D6E63,
                        ), // Brown color for noPreferente
                      ),
                    ),
                ],
              ),
            ),
          //AQUI COMIENZA LA SECCION EN CASA CON CHIP + SEGMENTED BUTTON
          const SizedBox(height: 16),
          if (_enCasa != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  // Chip acts as label
                  Chip(
                    avatar: const Icon(Icons.home),
                    label: const Text('En Casa'),
                    backgroundColor: const Color(
                      0xFF1976D2,
                    ), // Blue color for En Casa
                  ),
                  const SizedBox(
                    width: 12,
                  ), // Space between chip and segmented button
                  // SegmentedButton with true/false options
                  SegmentedButton<MigrationStatus>(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          // Check if the True segment is selected (enCasa = true)
                          if (_enCasa?.toLowerCase() == 'true') {
                            return Colors.green; // Green when True is selected
                          } else {
                            return Colors.red; // Red when False is selected
                          }
                        }
                        return null; // Use default color when not selected
                      }),
                    ),
                    segments: const <ButtonSegment<MigrationStatus>>[
                      ButtonSegment<MigrationStatus>(
                        value: MigrationStatus.migrationTrue,
                        label: Text('True'),
                      ),
                      ButtonSegment<MigrationStatus>(
                        value: MigrationStatus.migrationFalse,
                        label: Text('False'),
                      ),
                    ],
                    selected: <MigrationStatus>{
                      _enCasa?.toLowerCase() == 'true'
                          ? MigrationStatus.migrationTrue
                          : MigrationStatus.migrationFalse,
                    },
                    onSelectionChanged: (Set<MigrationStatus> newSelection) {
                      // This callback makes the button look active but doesn't change the actual value
                      // The selection is based on _enCasa value, so it will reset to the correct state
                      // on the next rebuild, but visually it looks interactive
                    },
                  ),
                ],
              ),
            ),
          //AQUI COMIENZA LA SECCION MIGRADO CON CHIP + SEGMENTED BUTTON
          const SizedBox(height: 16),
          if (_migrated != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  // Chip acts as label
                  Chip(
                    avatar: const Icon(Icons.swap_horiz),
                    label: const Text('Migrado'),
                    backgroundColor: const Color(0xFF770A0A),
                  ),
                  const SizedBox(
                    width: 12,
                  ), // Space between chip and segmented button
                  // SegmentedButton with true/false options
                  SegmentedButton<MigrationStatus>(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          // Check if the True segment is selected (migrated = true)
                          if (_migrated?.toLowerCase() == 'true') {
                            return Colors.green; // Green when True is selected
                          } else {
                            return Colors.red; // Red when False is selected
                          }
                        }
                        return null; // Use default color when not selected
                      }),
                    ),
                    segments: const <ButtonSegment<MigrationStatus>>[
                      ButtonSegment<MigrationStatus>(
                        value: MigrationStatus.migrationTrue,
                        label: Text('True'),
                      ),
                      ButtonSegment<MigrationStatus>(
                        value: MigrationStatus.migrationFalse,
                        label: Text('False'),
                      ),
                    ],
                    selected: <MigrationStatus>{
                      _migrated?.toLowerCase() == 'true'
                          ? MigrationStatus.migrationTrue
                          : MigrationStatus.migrationFalse,
                    },
                    onSelectionChanged: (Set<MigrationStatus> newSelection) {
                      // This callback makes the button look active but doesn't change the actual value
                      // The selection is based on _migrated value, so it will reset to the correct state
                      // on the next rebuild, but visually it looks interactive
                    },
                  ),
                ],
              ),
            ),
          //AQUI COMIENZA LA SECCION TOKEN TIPO CON CHIP + SEGMENTED BUTTON
          const SizedBox(height: 16),
          if (_tokenTipo != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  // Chip acts as label
                  Chip(
                    avatar: const Icon(Icons.token),
                    label: const Text('Token tipo'),
                    backgroundColor: const Color(
                      0xFF7B1FA2,
                    ), // Deep purple color for Token tipo
                  ),
                  const SizedBox(
                    width: 12,
                  ), // Space between chip and segmented button
                  // SegmentedButton with access/movistar/anonymous options
                  Expanded(
                    child: SegmentedButton<TokenTipo>(
                      segments: const <ButtonSegment<TokenTipo>>[
                        ButtonSegment<TokenTipo>(
                          value: TokenTipo.access,
                          label: Text('Access'),
                        ),
                        ButtonSegment<TokenTipo>(
                          value: TokenTipo.movistar,
                          label: Text('Movistar'),
                        ),
                        ButtonSegment<TokenTipo>(
                          value: TokenTipo.anonymous,
                          label: Text('Anonymous'),
                        ),
                      ],
                      selected: <TokenTipo>{
                        _tokenTipo?.toLowerCase() == 'access'
                            ? TokenTipo.access
                            : _tokenTipo?.toLowerCase() == 'movistar'
                            ? TokenTipo.movistar
                            : TokenTipo.anonymous,
                      },
                      onSelectionChanged: (Set<TokenTipo> newSelection) {
                        // This callback makes the button look active but doesn't change the actual value
                      },
                    ),
                  ),
                ],
              ),
            ),
          //AQUI COMIENZA LA SECCION LOGIN TIPO CON CHIP + SEGMENTED BUTTON
          const SizedBox(height: 16),
          if (_loginTipo != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  // Chip acts as label
                  Chip(
                    avatar: const Icon(Icons.login),
                    label: const Text('Login tipo'),
                    backgroundColor: const Color(
                      0xFF388E3C,
                    ), // Green color for Login tipo
                  ),
                  const SizedBox(
                    width: 12,
                  ), // Space between chip and segmented button
                  // SegmentedButton with credentials/autologin/anonymous options
                  Expanded(
                    child: SegmentedButton<LoginTipo>(
                      segments: const <ButtonSegment<LoginTipo>>[
                        ButtonSegment<LoginTipo>(
                          value: LoginTipo.credentials,
                          label: Text('Credentials'),
                        ),
                        ButtonSegment<LoginTipo>(
                          value: LoginTipo.autologin,
                          label: Text('Autologin'),
                        ),
                        ButtonSegment<LoginTipo>(
                          value: LoginTipo.anonymous,
                          label: Text('Anonymous'),
                        ),
                      ],
                      selected: <LoginTipo>{
                        _loginTipo?.toLowerCase() == 'credentials'
                            ? LoginTipo.credentials
                            : _loginTipo?.toLowerCase() == 'autologin'
                            ? LoginTipo.autologin
                            : LoginTipo.anonymous,
                      },
                      onSelectionChanged: (Set<LoginTipo> newSelection) {
                        // This callback makes the button look active but doesn't change the actual value
                      },
                    ),
                  ),
                ],
              ),
            ),
          //AQUI TERMINAN LOS CHIPS
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
