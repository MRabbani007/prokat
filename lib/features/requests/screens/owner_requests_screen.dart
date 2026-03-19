import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:prokat/core/widgets/edit_sheet.dart';
import 'package:prokat/core/widgets/industrial_input_container.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/bookings/widgets/category_icon.dart';
import 'package:prokat/features/bookings/widgets/info_bar.dart';
import 'package:prokat/features/requests/models/request_model.dart';
import 'package:prokat/features/requests/providers/request_provider.dart';

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
                  return _RequestSlidableCard(request: req);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestSlidableCard extends StatelessWidget {
  final RequestModel request;
  const _RequestSlidableCard({required this.request});

  @override
  Widget build(BuildContext context) {
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
            onTap: () => _openResponseSheet(context, request),
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

void _openResponseSheet(BuildContext context, RequestModel request) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EditSheet(
      title: "TRANSMIT OFFER",
      buttonText: "SEND PROPOSAL",
      onSubmit: () => Navigator.pop(context),
      child: Column(
        children: [
          // Technical Info Summary
          InfoBar(
            label: "TARGET CATEGORY",
            value: request.category?.name ?? "",
          ),
          const SizedBox(height: 16),

          // 1. Equipment Selector (Simulated Dropdown)
          IndustrialInputContainer(
            label: "SELECT DEPLOYABLE ASSET",
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: "KAMAZ-65115",
                dropdownColor: const Color(0xFF1E2125),
                items: ["KAMAZ-65115", "CAT-320", "MAN-TGS"]
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (_) {},
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 2. Schedule & Notes
          Row(
            children: [
              Expanded(
                child: IndustrialInputContainer(
                  label: "EST. START",
                  child: const Text(
                    "2024-03-25",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: IndustrialInputContainer(
                  label: "DURATION",
                  child: const Text(
                    "3 DAYS",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          IndustrialInputContainer(
            label: "OFFER COMMENT / TERMS",
            child: const TextField(
              maxLines: 2,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter mission specifics...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
