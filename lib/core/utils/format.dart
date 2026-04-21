import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatRequestTime(String date) {
  final dt = DateTime.parse(date).toLocal();
  final now = DateTime.now();

  final diff = now.difference(dt);

  if (diff.inMinutes < 1) return "Just now";
  if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
  if (diff.inHours < 24) return "${diff.inHours} h ago";

  // older → show date
  return DateFormat("d MMM, HH:mm").format(dt);
}

// String formatKZT(num amount) {
//   final formatter = NumberFormat("#,###", "en_US");
//   return "₸ ${formatter.format(amount).replaceAll(",", ",")}";
// }

String formatDate(DateTime date) {
  return DateFormat("d MMM yyyy").format(date);
}

String formatTime(BuildContext context, DateTime date) {
  return TimeOfDay.fromDateTime(date).format(context);
}

String formatPhoneNumber(String phoneNumber) {
  // 1. Remove all non-digit characters
  String cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');

  // 2. Handle Russian formatting (usually 11 digits, starting with 7 or 8)
  // If it starts with 8, replace with 7
  if (cleaned.length == 11 && cleaned.startsWith('8')) {
    cleaned = '7' + cleaned.substring(1);
  }

  // 3. Ensure it has 11 digits for this format
  if (cleaned.length != 11) {
    // Return original or handle error if format is invalid
    return phoneNumber;
  }

  // 4. Format: +7 111 222 3333
  return '+${cleaned[0]} ${cleaned.substring(1, 4)} ${cleaned.substring(4, 7)} ${cleaned.substring(7)}';
}

String formatPrice(dynamic price) {
  final number = (price is num)
      ? price
      : (double.tryParse(price.toString()) ?? 0);

  // Custom pattern using space as a separator
  final formatter = NumberFormat("#,###", "en_US");
  String formatted = formatter.format(number).replaceAll(',', ',');

  return "₸ $formatted";
}

String getPriceRate(dynamic priceRate) {
  final temp = priceRate.toString().trim().replaceAll(" ", "_").toUpperCase();

  return temp == "PER_TRIP"
      ? "/ Trip"
      : temp == "PER_CUBIC_METER"
      ? "/ M3"
      : temp == "PER HOUR"
      ? "/ Hour"
      : temp;
}

String getBookingStatus(dynamic status) {
  final temp = status.toString().trim().toUpperCase();

  switch (temp) {
    case "DRAFT":
      return "Draft";
    case "CREATED":
      return "New Order";
    case "CONFIRMED":
      return "Confirmed";
    case "REJECTED":
      return "Rejected";
    case "WITHDRAW":
      return "Canceled";
    case "FAILED":
      return "Canceled";
    case "COMPLETED":
      return "Completed";
    default:
      return "";
  }
}

MaterialColor getBookingColor(dynamic status) {
  final temp = status.toString().trim().toUpperCase();
  switch (temp) {
    case "DRAFT":
      return Colors.grey;
    case "CREATED":
      return Colors.blue;
    case "CONFIRMED":
      return Colors.green;
    case "REJECTED":
      return Colors.orange;
    case "WITHDRAW":
      return Colors.red;
    case "FAILED":
      return Colors.red;
    case "COMPLETED":
      return Colors.indigo;
    default:
      return Colors.brown;
  }
}

int getRemainingMinutes(dynamic createdAt, {int totalDuration = 60}) {
  try {
    // 1. Handle Null or empty values immediately
    if (createdAt == null || createdAt == "") return 0;

    DateTime? dt;

    // 2. Determine input type and parse accordingly
    if (createdAt is DateTime) {
      dt = createdAt;
    } else if (createdAt is String) {
      dt = DateTime.tryParse(createdAt); // Safely attempts to parse ISO8601
    }

    // 3. Check if parsing failed (not a valid date string)
    if (dt == null) return 0;

    // 4. Calculate difference (handling UTC vs Local)
    final now = dt.isUtc ? DateTime.now().toUtc() : DateTime.now();
    final difference = now.difference(dt).inMinutes;

    final remaining = totalDuration - difference;
    return remaining > 0 ? remaining : 0;
  } catch (e) {
    // 5. Catch-all for any unexpected errors (e.g., out-of-range dates)
    return 0;
  }
}
