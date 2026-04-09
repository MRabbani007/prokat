import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/requests/models/request_model.dart';
import 'package:prokat/features/requests/state/request_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/requests/widgets.dart/request_tile.dart';

class RenterRequestsHistoryScreen extends ConsumerWidget {
  const RenterRequestsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestProvider);
    const bgColor = Color(0xFF121417);
    // const accentColor = Color(0xFF4E73DF);

    final past = state.requests
        .where((r) => ["ACCEPTED", "CANCELLED", "EXPIRED"].contains(r.status))
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(child: PageHeader(title: "Request History")),
                  // Small technical Archive button
                  IconButton(
                    onPressed: () => context.push('/requests'),
                    icon: const Icon(
                      Icons.history_toggle_off_rounded,
                      color: Color(0x4DFFFFFF),
                      size: 24,
                    ),
                    tooltip: "Requests History",
                  ),
                ],
              ),
            ),

            Expanded(child: _buildContent(context, ref, state, [], past)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    state,
    List<RequestModel> active,
    List<RequestModel> past,
  ) {
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
        if (past.isNotEmpty) ...[
          _SectionLabel(label: "PAST REQUESTS"),
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
