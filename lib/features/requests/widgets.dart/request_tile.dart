import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prokat/features/requests/models/request_model.dart';
import 'package:prokat/features/requests/state/request_provider.dart';
import 'package:prokat/features/requests/widgets.dart/request_status_badge.dart';

class RequestTile extends ConsumerStatefulWidget {
  final RequestModel request;

  const RequestTile({super.key, required this.request});

  @override
  ConsumerState<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends ConsumerState<RequestTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const accentColor = Color(0xFF4E73DF);

    final request = widget.request;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 1. Top Row: Capacity & Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        request.capacity.toUpperCase(),
                        style: theme.textTheme.bodyLarge,
                      ),
                      Text(
                        (request.category?.capacityUnit ?? "").toUpperCase(),
                        style: theme.textTheme.bodyLarge,
                      ),
                      RequestStatusBadge(status: request.status),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// 2. Info Grid (Date & Price)
                  Row(
                    children: [
                      _buildInfoItem(
                        context: context,
                        icon: Icons.calendar_today_rounded,
                        label: "SCHEDULED FOR",
                        value: _formatDateTime(request),
                      ),
                      const SizedBox(width: 24),
                      _buildInfoItem(
                        context: context,
                        icon: Icons.payments_outlined,
                        label: "OFFERED RATE",
                        value: "${request.offeredRate} ₸",
                        valueColor: theme.primaryColor,
                      ),
                    ],
                  ),

                  /// 3. Comment Section
                  if (request.comment != null &&
                      request.comment!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Comment:",
                            style: theme.textTheme.labelMedium,
                          ),
                          Text(
                            request.comment!,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            /// 4. Action Bar (Conditional)
            if (request.status == "CREATED")
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () async {
                           final res = await ref
                                .read(requestProvider.notifier)
                                .cancelRequest(request.id);

                                if(res == true){}
                          },
                          icon: const Icon(Icons.close_rounded, size: 18),
                          label: const Text("CANCEL REQUEST"),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle:  TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1,
                              color: theme.colorScheme.onErrorContainer
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
   required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: valueColor ?? Colors.white.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(RequestModel r) {
    final dateStr = DateFormat('MMM dd').format(r.requiredOn!);
    if (r.requiredAt != null) {
      final timeStr = DateFormat('HH:mm').format(r.requiredAt!);
      return "$dateStr • $timeStr";
    }
    return dateStr;
  }
}
