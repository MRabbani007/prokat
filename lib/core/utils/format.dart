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

String formatKZT(num amount) {
  final formatter = NumberFormat("#,###", "en_US");
  return "${formatter.format(amount).replaceAll(",", " ")} ₸";
}

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
  String formatted = formatter.format(number).replaceAll(',', ' ');
  
  return "$formatted ₸";
}