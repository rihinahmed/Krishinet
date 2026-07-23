import 'package:krishinet/features/home/domain/entities/crop.dart';

class CropModel extends Crop {
  const CropModel({
    required super.id,
    required super.name,
    required super.currentPrice,
    required super.priceUnit,
    required super.priceChangePercent,
    required super.isUpTrend,
  });

  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      id: json['id'] as String,
      name: json['name'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      priceUnit: json['priceUnit'] as String,
      priceChangePercent: (json['priceChangePercent'] as num).toDouble(),
      isUpTrend: json['isUpTrend'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'currentPrice': currentPrice,
      'priceUnit': priceUnit,
      'priceChangePercent': priceChangePercent,
      'isUpTrend': isUpTrend,
    };
  }
}
