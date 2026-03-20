import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:prokat/features/bookings/widgets/category_icon.dart';
import 'package:prokat/features/offers/providers/offers_provider.dart';
import 'package:prokat/features/requests/models/request_model.dart';
import 'package:prokat/features/requests/widgets.dart/owner_create_offer_sheet.dart';

class OwnerRequestTile extends ConsumerWidget {
  final RequestModel request;

  const OwnerRequestTile({super.key, required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
