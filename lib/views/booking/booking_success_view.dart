import 'package:flutter/material.dart';
import '../../core/models/booking_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../customer/customer_dashboard_view.dart';
import '../shared/chat_dialog.dart';

class BookingSuccessView extends StatelessWidget {
  final BookingModel booking;
  const BookingSuccessView({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success badge
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accent, width: 2),
                      ),
                      child: const Center(
                        child: Icon(Icons.check, color: AppColors.accent, size: 40),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Session Successfully Booked!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Booking Reference: #${booking.id}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Booking summary box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDarkCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: Column(
                        children: [
                          _row('Trainer', booking.trainerName),
                          const SizedBox(height: 8),
                          _row('Service', booking.serviceTitle),
                          const SizedBox(height: 8),
                          _row('Date & Time', '${Formatters.formatDate(booking.scheduledDate)}, ${booking.timeSlot}'),
                          const SizedBox(height: 8),
                          _row('Location', '${booking.locationType} • ${booking.locationAddress}'),
                          const SizedBox(height: 8),
                          _row('Payment Mode', '${booking.paymentMethod} (Verified)'),
                          const Divider(height: 20),
                          _row('Total Paid', Formatters.formatINR(booking.price.totalAmount), isBold: true, color: AppColors.accent),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Reassurance card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.primaryLight, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${booking.trainerName} has received your booking details and will arrive with sanitized workout equipment.',
                              style: const TextStyle(fontSize: 12, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => ChatDialog(
                                  bookingId: booking.id,
                                  recipientName: booking.trainerName,
                                  isCustomerView: true,
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline, size: 18),
                            label: const Text('Message Trainer'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CustomerDashboardView(),
                                ),
                                (route) => route.isFirst,
                              );
                            },
                            icon: const Icon(Icons.dashboard_outlined, size: 18),
                            label: const Text('My Dashboard'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textDarkMuted),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: isBold ? 14 : 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color ?? Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

