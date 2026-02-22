import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final String equipmentId;
  const BookingScreen({super.key, required this.equipmentId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTimeRange? _selectedDateRange;
  bool _includeDelivery = false;
  final double _pricePerDay = 450.0;
  final double _deliveryFee = 150.0;

  @override
  Widget build(BuildContext context) {
    int totalDays = _selectedDateRange?.duration.inDays ?? 0;
    double subtotal = totalDays * _pricePerDay;
    double total = subtotal + (_includeDelivery ? _deliveryFee : 0);

    return Scaffold(
      appBar: AppBar(title: const Text("Finalize Booking")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Equipment Summary Mini-Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.construction,
                    color: Colors.orange,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.equipmentId.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text("Verified Machine • Atyrau Sector"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 2. Date Selection
            const Text(
              "Rental Period",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.black12),
              ),
              leading: const Icon(Icons.calendar_month, color: Colors.orange),
              title: Text(
                _selectedDateRange == null
                    ? "Select Dates"
                    : "${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}",
              ),
              subtitle: Text(
                totalDays > 0
                    ? "$totalDays days selected"
                    : "Tap to choose duration",
              ),
              onTap: _pickDateRange,
            ),
            const SizedBox(height: 30),

            // 3. Delivery Toggle
            const Text(
              "Logistics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text("Request Site Delivery"),
              subtitle: const Text("Additional \$150.00 for transport"),
              value: _includeDelivery,
              activeColor: Colors.orange,
              onChanged: (val) => setState(() => _includeDelivery = val),
            ),
            const Divider(height: 40),

            // 4. Price Breakdown
            const Text(
              "Cost Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _priceRow("Daily Rate", "\$$_pricePerDay x $totalDays"),
            if (_includeDelivery) _priceRow("Delivery Fee", "\$$_deliveryFee"),
            const Divider(),
            _priceRow(
              "Total Amount",
              "\$${total.toStringAsFixed(2)}",
              isTotal: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: totalDays > 0 ? () => _confirmBooking(total) : null,
            child: const Text(
              "CONFIRM & PAY",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.orange),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDateRange = picked);
  }

  void _confirmBooking(double total) {
    // Show a success snackbar or navigate to a Success Screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Booking request sent for \$${total.toStringAsFixed(2)}!",
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.bold,
              color: isTotal ? Colors.orange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
