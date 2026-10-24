class ReviewModel {
  final String id;
  final String bookingId;
  final String customerName;
  final String customerPhoto;
  final String trainerId;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final bool isVerifiedBooking;

  const ReviewModel({
    required this.id,
    required this.bookingId,
    required this.customerName,
    required this.customerPhoto,
    required this.trainerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.isVerifiedBooking = true,
  });
}
