import 'package:flutter/material.dart';
import '../../core/routes.dart';
import '../../data/repositories/status_repository.dart';

/// Splash screen that loads the JSON asset before navigating to Home.
class SplashScreen extends StatefulWidget {
  final StatusRepository repository;

  const SplashScreen({super.key, required this.repository});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
    _loadData();
  }

  Future<void> _loadData() async {
    // Pre-warm the cache while the splash is shown.
    await widget.repository.getData();

    // Ensure splash is shown for at least 1.5 s for a polished feel.
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFF1565C0),
      body: Stack(
        children: [
          // ── Centered logo + text ──────────────────────────────────────────
          FadeTransition(
            opacity: _fadeAnim,
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5),
                      ),
                      child: const Center(
                        child: Text(
                          'HTTP',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Status Code Guide',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Developer Reference',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.75),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 64),
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Footer ────────────────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + 24,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'made with ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.55),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Text(
                    '❤️',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    ' by AP & KK',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.75),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
