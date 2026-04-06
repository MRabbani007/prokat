import 'package:flutter/material.dart';
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
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// 1. Subtle background radial glow
            Positioned(
              top: -120,
              child: Container(
                width: 420,
                height: 420,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// 2. Branding
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Icon container
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: colorScheme.onSurface.withOpacity(0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.15),
                            blurRadius: 40,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.precision_manufacturing_rounded,
                        size: 64,
                        color: colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// App name
                    Text(
                      'PROKAT',
                      style: textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                        fontFamily: 'Oswald',
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Tagline
                    Text(
                      'HEAVY EQUIPMENT RENTALS',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.5,
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
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
                      color: colorScheme.primary.withOpacity(0.5),
                      backgroundColor: colorScheme.onSurface.withOpacity(0.05),
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
