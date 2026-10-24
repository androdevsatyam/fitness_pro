import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/app_state.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../discovery/trainer_discovery_view.dart';
import '../support/chat_dialog.dart';
import '../support/dispute_dialog.dart';
import 'review_dialog.dart';

class CustomerBookingsView extends StatefulWidget {
  const CustomerBookingsView({super.key});
  @override
  State<CustomerBookingsView> createState() => _CustomerBookingsViewState();
}

class _CustomerBookingsViewState extends State<CustomerBookingsView> {
  bool _past = false;
  Future<void> _cancel(BookingModel booking) async {
    final state = context.read<AppState>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel this session?'),
        content: const Text(
          'You can find another time when you are ready. Cancellation and payment handling are simulated in this prototype.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep session'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancel session'),
          ),
        ],
      ),
    );
    if (confirmed == true)
      state.updateBookingStatus(
        booking.id,
        BookingStatus.cancelled,
        reason: 'Cancelled by customer',
      );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final sessions = state.bookings
        .where((b) => b.customerId == state.currentUser.id)
        .where(
          (b) =>
              _past ==
              [
                BookingStatus.completed,
                BookingStatus.cancelled,
                BookingStatus.refunded,
                BookingStatus.disputed,
              ].contains(b.status),
        )
        .toList();
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TIME FOR YOURSELF',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 11,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your sessions, all together.',
                  style: TextStyle(fontFamily: 'Georgia', fontSize: 34),
                ),
                const SizedBox(height: 16),
                const Text('A little consistency goes a long way.'),
                const SizedBox(height: 28),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Upcoming')),
                    ButtonSegment(value: true, label: Text('Past sessions')),
                  ],
                  selected: {_past},
                  onSelectionChanged: (v) => setState(() => _past = v.first),
                ),
                const SizedBox(height: 32),
                if (sessions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 44),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 34,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 22),
                        Text(
                          _past
                              ? 'Your story is just beginning.'
                              : 'A little room in your calendar.',
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _past
                              ? 'Completed and cancelled sessions will appear here.'
                              : 'Find someone who can help you build a routine you enjoy.',
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TrainerSearchView(),
                            ),
                          ),
                          child: const Text('Explore trainers'),
                        ),
                      ],
                    ),
                  )
                else
                  for (final booking in sessions)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.status.displayName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                booking.serviceTitle,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('With ${booking.trainerName}'),
                              const SizedBox(height: 20),
                              Text(
                                '${Formatters.formatDate(booking.scheduledDate)} · ${booking.timeSlot}',
                                style: const TextStyle(color: AppColors.ink),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${booking.durationMinutes} minutes · ${Formatters.formatINR(booking.price.totalAmount)} total',
                              ),
                              if (booking.status == BookingStatus.confirmed)
                                const Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text(
                                    'Demo session check-in code: 2468',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                title: const Text(
                                  'Session details',
                                  style: TextStyle(fontSize: 14),
                                ),
                                childrenPadding: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${booking.locationAddress}\n\nBooking ${booking.id}\n${booking.paymentMethod} · Simulated payment',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 12,
                                runSpacing: 10,
                                children: [
                                  if (!_past)
                                    OutlinedButton(
                                      onPressed: () => showDialog(
                                        context: context,
                                        builder: (_) => ChatDialog(
                                          bookingId: booking.id,
                                          recipientName: booking.trainerName,
                                          isCustomerView: true,
                                        ),
                                      ),
                                      child: const Text('Message trainer'),
                                    ),
                                  if (!_past &&
                                      booking.status !=
                                          BookingStatus.inProgress)
                                    TextButton(
                                      onPressed: () => _cancel(booking),
                                      child: const Text('Cancel session'),
                                    ),
                                  if (booking.status ==
                                          BookingStatus.completed &&
                                      !booking.isReviewed)
                                    OutlinedButton(
                                      onPressed: () => showDialog(
                                        context: context,
                                        builder: (_) =>
                                            ReviewDialog(booking: booking),
                                      ),
                                      child: const Text(
                                        'Share your experience',
                                      ),
                                    ),
                                  TextButton(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (_) =>
                                          DisputeDialog(booking: booking),
                                    ),
                                    child: const Text('Get help'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
