import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/screens/menu_screen.dart';
import 'ui/screens/rules_screen.dart';
import 'ui/screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const CAMTTerminatorApp());
}

class CAMTTerminatorApp extends StatelessWidget {
  const CAMTTerminatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B0F1A),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF22B2FF),
        brightness: Brightness.dark,
      ),
      fontFamily: 'Orbitron', // remove if you didn’t add the font
      useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CAMT Terminator',
      theme: theme,
      routes: {
        '/': (_) => const MenuScreen(),
        '/rules': (_) => const RulesScreen(),
        // '/game': (_) => const GameScreen(), // placeholder
      },
    );
  }
}
