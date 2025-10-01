// project\camt_terminator\lib\main.dart
import 'package:camt_terminator/cubit/game_cubit.dart';
import 'package:camt_terminator/ui/widgets/dev_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/screens/menu_screen.dart';
import 'ui/screens/rules_screen.dart';
import 'ui/screens/combat_screen.dart';
import 'ui/screens/gameover_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const CAMTTerminatorApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CAMTTerminatorApp extends StatelessWidget {
  const CAMTTerminatorApp({super.key});

  // Toggle this to false for release builds
  // ignore: constant_identifier_names
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
      },
      // project\camt_terminator\lib\main.dart (inside builder:)
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              child!,
              if (DEV_MODE)
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Builder(
                    builder: (ctx) => FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        Scaffold.of(ctx).openEndDrawer();
                      },
                      child: const Icon(Icons.build),
                    ),
                  ),
                ),
            ],
          ),
          endDrawer: DEV_MODE
              ? DevPanel(
                  onDefeatBoss: () {
                    final ctx = navigatorKey.currentContext;
                    if (ctx != null) {
                      final continued = GameCubit.I.onBossDefeated(ctx);
                      if (!continued) return;
                      // If you're inside CombatScreen, you might want to trigger UI rebuild
                      // Use this only if needed
                      (ctx as Element).markNeedsBuild();
                    }
                  },
                )
              : null,
        );
      },
    );
  }
}
