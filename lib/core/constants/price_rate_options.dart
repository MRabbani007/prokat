class PriceRateOption {
  final String value;
  final String label;

  const PriceRateOption({
    required this.value,
    required this.label,
  });
}

const priceRateOptions = [
  PriceRateOption(value: "PER_HOUR", label: "Per Hour"),
  PriceRateOption(value: "PER_DAY", label: "Per Day"),
  PriceRateOption(value: "PER_TRIP", label: "Per Trip"),
  PriceRateOption(value: "PER_CUBIC_METER", label: "Per Cubic Meter"),
];

String getRateLabel(String value) {
  String? found = priceRateOptions.firstWhere((option) => option.value == value).label;
  return found;
}