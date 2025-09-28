// project\camt_terminator\lib\main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/screens/menu_screen.dart';
import 'ui/screens/rules_screen.dart';
import 'ui/screens/combat_screen.dart';
import 'ui/screens/gameover_screen.dart';
import 'ui/screens/dev_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const CAMTTerminatorApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CAMTTerminatorApp extends StatelessWidget {
  const CAMTTerminatorApp({super.key});

  // Toggle this to false for release builds
  static const DEV_MODE = true;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B0F1A),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF22B2FF),
        brightness: Brightness.dark,
      ),
      fontFamily: 'Orbitron',
      useMaterial3: true,
    );

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'CAMT Terminator',
      theme: theme,
      routes: {
        '/': (_) => const MenuScreen(),
        '/rules': (_) => const RulesScreen(),
        '/combat': (_) => const CombatScreen(),
        '/gameover': (_) => const GameoverScreen(),
        '/dev': (_) => const DevScreen(),
      },
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            if (DEV_MODE)
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    navigatorKey.currentState?.pushNamed('/dev');
                  },
                  child: const Icon(Icons.build),
                ),
              ),
          ],
        );
      },
    );
  }
}
