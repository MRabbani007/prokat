import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/requests/providers/request_provider.dart';
import 'package:prokat/features/requests/widgets.dart/owner_request_tile.dart';

class OwnerRequestsScreen extends ConsumerWidget {
  const OwnerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestProvider);

    final active = state.requests
        .where((r) => ["CREATED", "VIEWED"].contains(r.status))
        .toList();

    // final past = state.requests
    //     .where((r) => ["ACCEPTED", "CANCELLED", "EXPIRED"].contains(r.status))
    //     .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121417),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [ 
            const PageHeader(title: "Requests"),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: active.length,
                itemBuilder: (context, index) {
                  final req = active[index];
                  return OwnerRequestTile(request: req);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



