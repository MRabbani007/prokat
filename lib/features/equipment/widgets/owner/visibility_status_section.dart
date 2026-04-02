import 'package:flutter/material.dart';

class VisibilityStatusSection extends StatefulWidget {
  final bool isVisible;
  final String status;
  final Function(bool newVisibility, String newStatus) onSave;

  const VisibilityStatusSection({
    super.key,
    required this.isVisible,
    required this.status,
    required this.onSave,
  });

  @override
  State<VisibilityStatusSection> createState() =>
      _VisibilityStatusSectionState();
}

class _VisibilityStatusSectionState extends State<VisibilityStatusSection> {
  late bool _tempVisible;
  late String _tempStatus;

  @override
  void initState() {
    super.initState();
    _tempVisible = widget.isVisible;
    _tempStatus = widget.status;
  }

  bool get _isDirty =>
      (_tempVisible != widget.isVisible) || (_tempStatus != widget.status);

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1E2125);
    const ghostGray = Color(0x4DFFFFFF);
    const accentBlue = Color(0xFF4E73DF);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with State-Aware Save Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "STATUS",
                  style: TextStyle(
                    color: Color.fromARGB(255, 190, 190, 190),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                if (_isDirty)
                  TextButton.icon(
                    onPressed: () => widget.onSave(_tempVisible, _tempStatus),
                    icon: const Icon(Icons.sync_rounded, size: 16),
                    label: const Text("Save"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: accentBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: ghostGray,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),

          // is Visibile / available for rent
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            // decoration: BoxDecoration(
            //   color: Colors.black.withValues(alpha: 0.2),
            //   borderRadius: BorderRadius.circular(16),
            //   border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            // ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Available for rent",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: _tempVisible,
                  activeColor: accentBlue,
                  activeTrackColor: accentBlue.withValues(alpha: 0.3),
                  onChanged: (v) => setState(() => _tempVisible = v),
                ),
              ],
            ),
          ),

          // Equipment Status: Booked / Maintenance
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Operating Status",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 2. Industrial Status Selector
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["AVAILABLE", "BOOKED", "MAINTENANCE"].map((s) {
                  final isSelected = _tempStatus == s;
                  final isWarning = s == "MAINTENANCE";
                  final Color activeColor = isWarning
                      ? const Color(0xFFD97706)
                      : accentBlue;

                  return GestureDetector(
                    onTap: () => setState(() => _tempStatus = s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? activeColor.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? activeColor
                              : Colors.white.withValues(alpha: 0.05),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        s,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: isSelected ? activeColor : ghostGray,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
