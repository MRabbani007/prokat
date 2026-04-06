import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final bool showBack;

  const PageHeader({super.key, required this.title, this.showBack = true});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showBack)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                color: const Color.fromARGB(255, 61, 63, 65),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                },
              ),

            SizedBox(width: 8),

            /// Title fills remaining space
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 61, 63, 65),
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
