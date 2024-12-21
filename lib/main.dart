import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              primaryColor: Colors.blueGrey,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
              ),
            )
          : ThemeData.light().copyWith(
              primaryColor: Colors.blue,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
      home: DialerScreen(
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

class DialerScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const DialerScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<DialerScreen> createState() => _DialerScreenState();
}

class _DialerScreenState extends State<DialerScreen> {
  String enteredNumber = "";

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDialButtonPressed(String text) {
    setState(() {
      enteredNumber += text;
    });
  }

  void _onDeleteButtonPressed() {
    setState(() {
      if (enteredNumber.isNotEmpty) {
        enteredNumber = enteredNumber.substring(0, enteredNumber.length - 1);
      }
    });
  }

  Future<void> _openWhatsApp() async {
    if (enteredNumber.isNotEmpty && enteredNumber.length >= 10) {
      String countryCode = "+91";
      String whatsappUrl = "https://wa.me/$countryCode$enteredNumber";

      final uri = Uri.parse(whatsappUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch WhatsApp')),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
    }
  }

  Widget buildDialButton(String text) {
    return ElevatedButton(
      onPressed: () => _onDialButtonPressed(text),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: widget.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    enteredNumber,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  for (var row in [
                    ["1", "2", "3"],
                    ["4", "5", "6"],
                    ["7", "8", "9"],
                    ["*", "0", "#"],
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            row.map((text) => buildDialButton(text)).toList(),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.backspace, color: Colors.grey),
                    iconSize: 30,
                    onPressed: _onDeleteButtonPressed,
                  ),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: _openWhatsApp,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(18),
                      backgroundColor: Colors.green,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
