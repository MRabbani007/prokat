int? parseNullableInt(dynamic value) {
  if (value == null) return null;

  if (value is int) return value;

  if (value is String) {
    return int.tryParse(value);
  }

  return null;
}

DateTime? parseNullableDate(dynamic value) {
  if (value == null) return null;

  try {
    // Already a DateTime
    if (value is DateTime) return value;

    // ISO string or other string formats
    if (value is String) {
      if (value.trim().isEmpty) return null;
      return DateTime.tryParse(value);
    }

    // Unix timestamp (seconds or milliseconds)
    if (value is int) {
      // Detect seconds vs milliseconds
      if (value > 1000000000000) {
        // milliseconds
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else {
        // seconds
        return DateTime.fromMillisecondsSinceEpoch(value * 1000);
      }
    }

    // Double timestamp (rare but possible)
    if (value is double) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
  } catch (_) {
    // swallow any unexpected parsing errors
  }

  return null;
}

bool parseBoolean(dynamic value) {
  if (value == null) return false;

  try {
    if (value.toString().trim().toLowerCase() == "true") {
      return true;
    }
    return false;
  } catch (_) {
    return false;
  }
}
