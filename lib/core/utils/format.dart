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