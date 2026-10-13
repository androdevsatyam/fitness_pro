enum BookingStatus {
  requested,
  pendingAcceptance,
  confirmed,
  inProgress,
  completed,
  cancelled,
  disputed,
  refunded;

  String get displayName {
    switch (this) {
      case BookingStatus.requested:
        return 'Request Sent';
      case BookingStatus.pendingAcceptance:
        return 'Awaiting Trainer';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'Session In-Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.disputed:
        return 'Under Dispute';
      case BookingStatus.refunded:
        return 'Refunded';
    }
  }
}

class PriceBreakdown {
  final double basePrice;
  final double platformFee;
  final double travelFee;
  final double discountAmount;
  final double gstAmount; // 18% GST
  final double totalAmount;

  const PriceBreakdown({
    required this.basePrice,
    required this.platformFee,
    required this.travelFee,
    required this.discountAmount,
    required this.gstAmount,
    required this.totalAmount,
  });

  factory PriceBreakdown.calculate({
    required double basePrice,
    required double platformFeePercent,
    required double travelFee,
    required double discountAmount,
  }) {
    final subtotal = (basePrice + travelFee - discountAmount).clamp(0.0, double.infinity);
    final platformFee = basePrice * (platformFeePercent / 100);
    final taxableAmount = subtotal + platformFee;
    final gst = taxableAmount * 0.18; // 18% GST on services in India
    final total = taxableAmount + gst;

    return PriceBreakdown(
      basePrice: basePrice,
      platformFee: platformFee,
      travelFee: travelFee,
      discountAmount: discountAmount,
      gstAmount: gst,
      totalAmount: total,
    );
  }
}

class BookingModel {
  final String id;
  final String trainerId;
  final String trainerName;
  final String trainerPhoto;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String serviceTitle;
  final String serviceCategory;
  final int durationMinutes;
  final DateTime scheduledDate;
  final String timeSlot;
  final String locationAddress;
  final String locationType; // Home, Society Gym, Public Park
  final PriceBreakdown price;
  final BookingStatus status;
  final String paymentMethod; // UPI, Credit Card, Netbanking
  final String paymentTransactionId;
  final String? promoCodeApplied;
  final DateTime? slotHoldExpiry;
  final DateTime? checkInTime;
  final DateTime? completedTime;
  final String? cancellationReason;
  final bool isReviewed;

  const BookingModel({
    required this.id,
    required this.trainerId,
    required this.trainerName,
    required this.trainerPhoto,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.serviceTitle,
    required this.serviceCategory,
    required this.durationMinutes,
    required this.scheduledDate,
    required this.timeSlot,
    required this.locationAddress,
    this.locationType = 'Customer Home',
    required this.price,
    this.status = BookingStatus.confirmed,
    this.paymentMethod = 'UPI (Google Pay)',
    this.paymentTransactionId = 'TXN_IN_89472891',
    this.promoCodeApplied,
    this.slotHoldExpiry,
    this.checkInTime,
    this.completedTime,
    this.cancellationReason,
    this.isReviewed = false,
  });

  BookingModel copyWith({
    String? id,
    String? trainerId,
    String? trainerName,
    String? trainerPhoto,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? serviceTitle,
    String? serviceCategory,
    int? durationMinutes,
    DateTime? scheduledDate,
    String? timeSlot,
    String? locationAddress,
    String? locationType,
    PriceBreakdown? price,
    BookingStatus? status,
    String? paymentMethod,
    String? paymentTransactionId,
    String? promoCodeApplied,
    DateTime? slotHoldExpiry,
    DateTime? checkInTime,
    DateTime? completedTime,
    String? cancellationReason,
    bool? isReviewed,
  }) {
    return BookingModel(
      id: id ?? this.id,
      trainerId: trainerId ?? this.trainerId,
      trainerName: trainerName ?? this.trainerName,
      trainerPhoto: trainerPhoto ?? this.trainerPhoto,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeSlot: timeSlot ?? this.timeSlot,
      locationAddress: locationAddress ?? this.locationAddress,
      locationType: locationType ?? this.locationType,
      price: price ?? this.price,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
      promoCodeApplied: promoCodeApplied ?? this.promoCodeApplied,
      slotHoldExpiry: slotHoldExpiry ?? this.slotHoldExpiry,
      checkInTime: checkInTime ?? this.checkInTime,
      completedTime: completedTime ?? this.completedTime,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      isReviewed: isReviewed ?? this.isReviewed,
    );
  }
}

