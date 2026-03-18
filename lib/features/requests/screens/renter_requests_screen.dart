import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/requests/providers/request_provider.dart';
import 'package:prokat/features/requests/widgets.dart/request_tile.dart';

class RenterRequestsScreen extends ConsumerWidget {
  const RenterRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestProvider);
    const bgColor = Color(0xFF121417);
    const accentColor = Color(0xFF4E73DF);

    final active = state.requests
        .where((r) => ["CREATED", "VIEWED"].contains(r.status))
        .toList();

    final past = state.requests
        .where((r) => ["ACCEPTED", "CANCELLED", "EXPIRED"].contains(r.status))
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(title: "My Requests"),

            Expanded(child: _buildContent(context, ref, state, active, past)),

            /// ➕ CREATE REQUEST FOOTER
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/requests/create'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                  label: const Text(
                    "CREATE NEW REQUEST",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(context, ref, state, active, past) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF4E73DF)),
      );
    }

    if (state.error != null) {
      return Center(
        child: Text(
          "Error: ${state.error}",
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }

    if (state.requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),
            Text(
              "No requests found",
              style: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        if (active.isNotEmpty) ...[
          _SectionLabel(label: "ACTIVE REQUESTS"),
          const SizedBox(height: 12),
          ...active.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RequestTile(
                request: r,
                onCancel: () =>
                    ref.read(requestProvider.notifier).cancelRequest(r.id),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (past.isNotEmpty) ...[
          _SectionLabel(label: "PAST HISTORY"),
          const SizedBox(height: 12),
          ...past.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RequestTile(request: r),
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.3),
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }
}
