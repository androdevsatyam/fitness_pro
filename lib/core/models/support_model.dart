enum TicketStatus {
  open,
  underReview,
  resolved,
  closed;

  String get displayName {
    switch (this) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.underReview:
        return 'Under Investigation';
      case TicketStatus.resolved:
        return 'Resolved';
      case TicketStatus.closed:
        return 'Closed';
    }
  }
}

enum TicketPriority { low, medium, high, urgent }

class SupportTicketModel {
  final String id;
  final String bookingId;
  final String customerName;
  final String trainerName;
  final String
  category; // 'Trainer Late / No-show', 'Wrong Location', 'Refund Request', 'Safety Concern'
  final String description;
  final TicketPriority priority;
  final TicketStatus status;
  final DateTime createdAt;
  final double requestedRefundInr;
  final String? resolutionNotes;

  const SupportTicketModel({
    required this.id,
    required this.bookingId,
    required this.customerName,
    required this.trainerName,
    required this.category,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.requestedRefundInr = 0,
    this.resolutionNotes,
  });

  SupportTicketModel copyWith({
    String? id,
    String? bookingId,
    String? customerName,
    String? trainerName,
    String? category,
    String? description,
    TicketPriority? priority,
    TicketStatus? status,
    DateTime? createdAt,
    double? requestedRefundInr,
    String? resolutionNotes,
  }) {
    return SupportTicketModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      customerName: customerName ?? this.customerName,
      trainerName: trainerName ?? this.trainerName,
      category: category ?? this.category,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      requestedRefundInr: requestedRefundInr ?? this.requestedRefundInr,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
    );
  }
}
