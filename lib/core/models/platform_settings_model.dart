class PromoCode {
  final String code;
  final double discountPercent;
  final double maxDiscountInr;
  final double minBookingAmountInr;
  final String description;

  const PromoCode({
    required this.code,
    required this.discountPercent,
    required this.maxDiscountInr,
    required this.minBookingAmountInr,
    required this.description,
  });

  double calculateDiscount(double amount) {
    if (amount < minBookingAmountInr) return 0.0;
    final discount = amount * (discountPercent / 100);
    return discount > maxDiscountInr ? maxDiscountInr : discount;
  }
}

class PlatformSettingsModel {
  final double platformCommissionPercent;
  final double baseTravelFeeInr;
  final double gstPercent;
  final int minNoticeHours;
  final List<PromoCode> promoCodes;

  const PlatformSettingsModel({
    this.platformCommissionPercent = 12.0, // 12% configurable platform take rate
    this.baseTravelFeeInr = 100.0,
    this.gstPercent = 18.0,
    this.minNoticeHours = 2,
    this.promoCodes = const [
      PromoCode(
        code: 'FITFIRST',
        discountPercent: 20.0,
        maxDiscountInr: 300.0,
        minBookingAmountInr: 600.0,
        description: '20% off up to ₹300 on your first personal training session',
      ),
      PromoCode(
        code: 'HEALTHY10',
        discountPercent: 10.0,
        maxDiscountInr: 200.0,
        minBookingAmountInr: 800.0,
        description: '10% off up to ₹200 for regular fitness sessions',
      ),
    ],
  });

  PlatformSettingsModel copyWith({
    double? platformCommissionPercent,
    double? baseTravelFeeInr,
    double? gstPercent,
    int? minNoticeHours,
    List<PromoCode>? promoCodes,
  }) {
    return PlatformSettingsModel(
      platformCommissionPercent:
          platformCommissionPercent ?? this.platformCommissionPercent,
      baseTravelFeeInr: baseTravelFeeInr ?? this.baseTravelFeeInr,
      gstPercent: gstPercent ?? this.gstPercent,
      minNoticeHours: minNoticeHours ?? this.minNoticeHours,
      promoCodes: promoCodes ?? this.promoCodes,
    );
  }
}

