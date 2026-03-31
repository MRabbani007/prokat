import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/offers/models/offer_model.dart';
import 'package:prokat/features/offers/providers/offers_provider.dart';
import 'package:prokat/features/requests/providers/request_provider.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(requestProvider);
    final offersState = ref.watch(offersProvider);

    final active = state.requests
        .where((r) => ["CREATED", "VIEWED"].contains(r.status))
        .toList();

    final offers = offersState.ownerOffers.where(
      (r) => ["CREATED", "VIEWED"].contains(r.status),
    );

    final offersByRequest = <String, List<OfferModel>>{};

    for (final offer in offers) {
      final requestId = offer.requestId;

      if (!offersByRequest.containsKey(requestId)) {
        offersByRequest[requestId] = [];
      }

      offersByRequest[requestId]!.add(offer);
    }

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
                  final requestOffers = offersByRequest[req.id] ?? [];
                  print(requestOffers);
                  return OwnerRequestTile(request: req, offers: requestOffers);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
