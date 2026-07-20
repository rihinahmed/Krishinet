class Crop {
  final String id;
  final String name;
  final double currentPrice;
  final String priceUnit;
  final double priceChangePercent;
  final bool isUpTrend;

  const Crop({
    required this.id,
    required this.name,
    required this.currentPrice,
    required this.priceUnit,
    required this.priceChangePercent,
    required this.isUpTrend,
  });
}
