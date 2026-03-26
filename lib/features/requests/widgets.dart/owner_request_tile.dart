import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:prokat/features/bookings/widgets/category_icon.dart';
import 'package:prokat/features/offers/models/offer_model.dart';
import 'package:prokat/features/offers/providers/offers_provider.dart';
import 'package:prokat/features/requests/models/request_model.dart';
import 'package:prokat/features/requests/widgets.dart/owner_create_offer_sheet.dart';

enum OwnerRequestUIState {
  newRequest, // request CREATED, no offer
  viewed, // request VIEWED, no offer
  offerSent, // offer exists (CREATED/VIEWED)
  hidden, // hidden locally
  accepted, // offer ACCEPTED
}

OwnerRequestUIState getOwnerRequestState(
  RequestModel request,
  List<OfferModel> offers,
) {
  if (offers.isEmpty) {
    if (request.status == "CREATED") return OwnerRequestUIState.newRequest;
    if (request.status == "VIEWED") return OwnerRequestUIState.viewed;
  }

  final offer = offers.first; // you said 1 offer per request

  if (offer.status == "ACCEPTED") {
    return OwnerRequestUIState.accepted;
  }

  return OwnerRequestUIState.offerSent;
}

class OwnerRequestUIConfig {
  final String label;
  final Color color;

  const OwnerRequestUIConfig({required this.label, required this.color});
}

OwnerRequestUIConfig getOwnerRequestUIConfig(OwnerRequestUIState state) {
  switch (state) {
    case OwnerRequestUIState.newRequest:
      return const OwnerRequestUIConfig(
        label: "NEW REQUEST",
        color: Colors.orange,
      );

    case OwnerRequestUIState.viewed:
      return const OwnerRequestUIConfig(label: "VIEWED", color: Colors.white54);

    case OwnerRequestUIState.offerSent:
      return const OwnerRequestUIConfig(
        label: "OFFER SENT",
        color: Colors.blue,
      );

    case OwnerRequestUIState.accepted:
      return const OwnerRequestUIConfig(label: "ACCEPTED", color: Colors.green);

    case OwnerRequestUIState.hidden:
      return const OwnerRequestUIConfig(label: "HIDDEN", color: Colors.white24);
  }
}

class OwnerRequestTile extends ConsumerWidget {
  final RequestModel request;
  final List<OfferModel>? offers;

  const OwnerRequestTile({
    super.key,
    required this.request,
    required this.offers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = getOwnerRequestState(request, offers ?? []);
    final uiConfig = getOwnerRequestUIConfig(uiState);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (_) {}, // HIDE Logic
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                foregroundColor: Colors.white38,
                icon: Icons.visibility_off_outlined,
                label: 'HIDE',
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              if (uiState == OwnerRequestUIState.offerSent) {
                // maybe open offer details instead
                return;
              }

              if (uiState == OwnerRequestUIState.accepted) {
                // open booking / tracking
                return;
              }

              ref.read(offersProvider.notifier).selectRequest(request);
              openResponseSheet(context, request);
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2125),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  CategoryIcon(category: request.category?.name ?? ""),

                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // if (uiState == OwnerRequestUIState.offerSent)
                        //   Container(
                        //     margin: const EdgeInsets.only(bottom: 6),
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 8,
                        //       vertical: 4,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: uiConfig.color.withValues(alpha: 0.15),
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //     child: Text(
                        //       uiConfig.label,
                        //       style: TextStyle(
                        //         color: uiConfig.color,
                        //         fontSize: 10,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: uiConfig.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            uiConfig.label,
                            style: TextStyle(
                              color: uiConfig.color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "OPEN REQUEST • ${request.requiredOn}",
                          style: const TextStyle(
                            color: Color(0xFFD97706),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Text(
                              request.category?.name ?? "Septic Truck",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              request.capacity,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              request.category?.capacityUnit ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          request.offeredRate.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          request.location.street,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.bolt, color: Color(0xFFD97706), size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
