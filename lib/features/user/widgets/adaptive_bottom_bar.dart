import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';

class AdaptiveFooterCard extends StatelessWidget {
  final double progress; // 0.0 at top/middle, 1.0 at very bottom

  const AdaptiveFooterCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpanded = progress > 0.5;

    return Container(
      margin: EdgeInsets.lerp(
        const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        progress,
      ),
      child: Material(
        elevation: 8,
        shadowColor: theme.colorScheme.primary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(isExpanded ? 28 : 50),
        color: theme.colorScheme.primary,
        child: InkWell(
          onTap: () => context.push(AppRoutes.searchList),
          borderRadius: BorderRadius.circular(28),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.lerp(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              const EdgeInsets.all(24),
              progress,
            ),
            child: isExpanded
                ? Stack(
                    children: [
                      // Decorative background icon (Subtle "Truck" watermark)
                      Positioned(
                        right: -20,
                        bottom: -10,
                        child: Icon(
                          Icons.local_shipping_rounded,
                          size: 120,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            // Icon Container
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.search_rounded, // Search or ManageSearch
                                color: Colors.white,
                                size: 32,
                              ),
                            ),

                            const SizedBox(width: 20),

                            // Text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Find & Rent",
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 22,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Browse heavy equipment near you",
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Small White Chevron
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ) // Your full Row/Stack code
                : _buildCollapsedContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search, color: Colors.white, size: 20),
        SizedBox(width: 8),
        Text(
          "Find & Rent",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
