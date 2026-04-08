import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.dark, // Use light if using a dark theme
      ),
    );

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const _OutProposedCurve()),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(AppRoutes.dashboard);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      // Ensure the scaffold extends behind system cutouts
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// 1. Background Glows (Layered for depth)
          // Primary top-right glow
          Positioned(
            top: -150,
            right: -100,
            child: _BackgroundGlow(
              color: colorScheme.primary.withValues(alpha: 0.15),
              size: 500,
            ),
          ),
          // Subtle bottom-left glow for balance
          Positioned(
            bottom: -100,
            left: -100,
            child: _BackgroundGlow(
              color: colorScheme.primary.withValues(alpha: 0.05),
              size: 400,
            ),
          ),

          /// 2. Branding (Centered)
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            blurRadius: 40,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.precision_manufacturing_rounded,
                        size: 72, // Slightly larger for "heavy" impact
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'PROKAT',
                      style: textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w900, // Black weight
                        letterSpacing: 8,
                        fontFamily: 'Oswald',
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'HEAVY EQUIPMENT RENTALS',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 3. Loader
          Positioned(
            bottom: 80,
            child: Column(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary.withValues(alpha: 0.5),
                    backgroundColor: colorScheme.onSurface.withValues(alpha: 0.05),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'LOADING',
                  style: textTheme.labelLarge?.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom curve for a "heavy / industrial" feel
class _OutProposedCurve extends Curve {
  const _OutProposedCurve();

  @override
  double transformInternal(double t) {
    return 1.0 - (1.0 - t) * (1.0 - t) * (1.0 - t);
  }
}

class _BackgroundGlow extends StatelessWidget {
  final Color color;
  final double size;

  const _BackgroundGlow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.2, 1.0],
        ),
      ),
    );
  }
}
