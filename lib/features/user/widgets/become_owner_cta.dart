import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BecomeOwnerCTA extends StatelessWidget {
  const BecomeOwnerCTA({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.storefront),
          label: const Text('Become an Equipment Owner'),
          style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: const EdgeInsets.symmetric(vertical: 24),
            textStyle: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            context.push('/become-owner');
          },
        ),
      ),
    );
  }
}
