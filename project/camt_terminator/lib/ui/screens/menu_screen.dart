// project\camt_terminator\lib\ui\screens\menu_screen.dart
import 'dart:ui';
import 'package:camt_terminator/ui/screens/combat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // ---- background: soft space gradient + subtle stars noise ----
          const _SpaceBackground(),
          // ---- glass card with content ----
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: _GlassPanel(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        // Title with weapons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _WeaponIcon(
                              path: 'assets/images/knife.png',
                              flip: false,
                            ),
                            SizedBox(width: width * 0.04),
                            Column(
                              children: const [
                                _NeonText(
                                  'CAMT',
                                  size: 40,
                                  color: Color(0xFFFFB74D),
                                ),
                                SizedBox(height: 2),
                                _NeonText(
                                  'Terminator',
                                  size: 18,
                                  color: Color(0xFFFFB74D),
                                ),
                              ],
                            ),
                            SizedBox(width: width * 0.04),
                            _WeaponIcon(
                              path: 'assets/images/shotgun.png',
                              flip: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Buttons
                        _NeonButton(
                          label: 'Start',
                          borderColor: const Color(0xFFFF77E9),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CombatScreen(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                        _NeonButton(
                          label: 'Rule',
                          borderColor: const Color(0xFF6BFF78), // lime
                          onTap: () => Navigator.pushNamed(context, '/rules'),
                        ),
                        const SizedBox(height: 12),
                        _NeonButton(
                          label: 'Exit',
                          borderColor: const Color(0xFFFF5A5A), // red
                          onTap: () async {
                            await HapticFeedback.mediumImpact();
                            SystemNavigator.pop();
                          },
                        ),
                        const SizedBox(height: 20),
                        // Footer
                        const Opacity(
                          opacity: 0.75,
                          child: Text(
                            'version 1.0',
                            style: TextStyle(letterSpacing: 1.2, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Opacity(
                          opacity: 0.55,
                          child: Text(
                            'made by ________',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== widgets ===================== */

class _SpaceBackground extends StatelessWidget {
  const _SpaceBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B0F1A), Color(0xFF0E1530), Color(0xFF0B0F1A)],
        ),
      ),
      child: Stack(
        children: [
          // faint vignette
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [Colors.white.withValues(alpha: .06), Colors.transparent],
                ),
              ),
            ),
          ),
          // stars layer (simple noise dots)
          Positioned.fill(child: CustomPaint(painter: _StarPainter())),
        ],
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x6600C6FF),
                blurRadius: 24,
                spreadRadius: -6,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _WeaponIcon extends StatelessWidget {
  const _WeaponIcon({required this.path, this.flip = false});
  final String path;
  final bool flip;

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(
      path,
      height: 48,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.image_not_supported, size: 40),
    );

    return Transform.scale(scaleX: flip ? -1 : 1, child: img);
  }
}

class _NeonText extends StatelessWidget {
  const _NeonText(this.text, {required this.size, required this.color});
  final String text;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: color,
        shadows: [
          Shadow(color: color.withOpacity(0.6), blurRadius: 16),
          Shadow(color: color.withOpacity(0.3), blurRadius: 32),
        ],
      ),
    );
  }
}

class _NeonButton extends StatelessWidget {
  const _NeonButton({
    required this.label,
    required this.onTap,
    required this.borderColor,
  });

  final String label;
  final VoidCallback onTap;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: InkWell(
        onTap: () async {
          await HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
            color: Colors.black.withOpacity(0.22),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.5),
                blurRadius: 18,
                spreadRadius: -2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: borderColor,
                shadows: [
                  Shadow(color: borderColor.withOpacity(0.8), blurRadius: 14),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* tiny star painter for subtle background texture */
class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.10);
    final rnd = _XorShift(123456);
    for (int i = 0; i < 180; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final r = 0.6 + rnd.nextDouble() * 1.1;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _XorShift {
  int _state;
  _XorShift(this._state);
  double nextDouble() {
    var x = _state;
    x ^= (x << 13) & 0xFFFFFFFF;
    x ^= (x >> 17);
    x ^= (x << 5) & 0xFFFFFFFF;
    _state = x;
    return (x & 0x7FFFFFFF) / 0x7FFFFFFF;
  }
}
