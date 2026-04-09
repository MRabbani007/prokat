import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/offers/models/offer_model.dart';
import 'package:prokat/features/offers/providers/offers_provider.dart';
import 'package:prokat/features/requests/state/request_provider.dart';
import 'package:prokat/features/requests/widgets.dart/owner_request_skeleton.dart';
import 'package:prokat/features/requests/widgets.dart/owner_request_tile.dart';

class OwnerRequestsScreen extends ConsumerStatefulWidget {
  const OwnerRequestsScreen({super.key});

  @override
  ConsumerState<OwnerRequestsScreen> createState() =>
      _OwnerRequestsScreenState();
}

class _OwnerRequestsScreenState extends ConsumerState<OwnerRequestsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(offersProvider.notifier).getOwnerOffers();
      ref.read(requestProvider.notifier).getOwnerRequests();
      ref.read(equipmentProvider.notifier).getOwnerEquipment();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final requestState = ref.watch(requestProvider);
    final offersState = ref.watch(offersProvider);

    /// 🎯 Filter active requests
    final activeRequests = requestState.requests
        .where((r) => ["CREATED", "VIEWED"].contains(r.status))
        .toList();

    /// 🎯 Group offers by requestId
    final offersByRequest = <String, List<OfferModel>>{};

    for (final offer in offersState.ownerOffers) {
      if (!["CREATED", "VIEWED"].contains(offer.status)) continue;

      offersByRequest.putIfAbsent(offer.requestId, () => []);
      offersByRequest[offer.requestId]!.add(offer);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /// 🔹 Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: PageHeader(title: "Requests"),
              ),
            ),

            /// 🔹 Empty state
            if (requestState.isLoading)
              SliverToBoxAdapter(child: RequestTileSkeleton())
            else if (activeRequests.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    "No active requests",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final request = activeRequests[index];
                    final requestOffers = offersByRequest[request.id] ?? [];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: OwnerRequestTile(
                        request: request,
                        offers: requestOffers,
                      ),
                    );
                  }, childCount: activeRequests.length),
                ),
              ),
          ],
        ),
      ),
    );
  }
}