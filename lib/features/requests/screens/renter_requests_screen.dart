import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import 'package:prokat/features/offers/providers/offers_provider.dart';
import 'package:prokat/features/requests/state/request_provider.dart';
import 'package:prokat/features/requests/widgets.dart/request_with_offers.dart';

class RenterRequestsScreen extends ConsumerStatefulWidget {
  const RenterRequestsScreen({super.key});

  @override
  ConsumerState<RenterRequestsScreen> createState() =>
      _RenterRequestsScreenState();
}

class _RenterRequestsScreenState extends ConsumerState<RenterRequestsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(offersProvider.notifier).getUserOffers();
      ref.read(requestProvider.notifier).getUserRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final authSession = ref.watch(authProvider).session;
    final state = ref.watch(requestProvider);
    final offersState = ref.watch(offersProvider);
    const bgColor = Color(0xFF121417);
    const accentColor = Color(0xFF4E73DF);

    final active = state.requests
        .where((r) => ["CREATED", "VIEWED"].contains(r.status))
        .toList();

    final offers = offersState.renterOffers.where(
      (r) => ["CREATED", "VIEWED"].contains(r.status),
    );

    final offersByRequest = <String, List<dynamic>>{};

    for (final offer in offers) {
      final requestId = offer.requestId;

      if (!offersByRequest.containsKey(requestId)) {
        offersByRequest[requestId] = [];
      }

      offersByRequest[requestId]!.add(offer);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(child: PageHeader(title: "My Requests")),
                  // Small technical Archive button
                  IconButton(
                    onPressed: () => authSession == null
                        ? null
                        : context.push('/requests/history'),
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

            authSession == null
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.login_outlined,
                            size: 64,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Login to create and view requests",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: state.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF4E73DF),
                            ),
                          )
                        : state.error != null
                        ? Center(
                            child: Text(
                              "Error: ${state.error}",
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          )
                        : state.requests.isEmpty
                        ? Center(
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
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.90),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            children: [
                              if (active.isNotEmpty) ...[
                                Text(
                                  "ACTIVE REQUESTS",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),

                                const SizedBox(height: 12),
                                ...active.map((r) {
                                  final requestOffers =
                                      offersByRequest[r.id] ?? [];

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: RequestWithOffers(
                                      request: r,
                                      offers: requestOffers,
                                      onCancel: () => ref
                                          .read(requestProvider.notifier)
                                          .cancelRequest(r.id),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 24),
                              ],
                            ],
                          ),
                  ),

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
                  onPressed: () => authSession == null
                      ? null
                      : context.push('/requests/create'),
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
}
