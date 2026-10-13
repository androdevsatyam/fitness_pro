import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../core/models/booking_model.dart';
import '../public/trainer_search_view.dart';
import '../shared/chat_dialog.dart';
import '../shared/review_dialog.dart';
import '../shared/dispute_dialog.dart';
import '../onboarding/customer_onboarding_view.dart';

class CustomerDashboardView extends StatefulWidget {
  const CustomerDashboardView({super.key});

  @override
  State<CustomerDashboardView> createState() => _CustomerDashboardViewState();
}

class _CustomerDashboardViewState extends State<CustomerDashboardView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isDesktop = Responsive.isDesktop(context);

    final upcomingBookings = state.bookings.where((b) =>
        b.status == BookingStatus.confirmed ||
        b.status == BookingStatus.requested ||
        b.status == BookingStatus.pendingAcceptance ||
        b.status == BookingStatus.inProgress).toList();

    final pastBookings = state.bookings.where((b) =>
        b.status == BookingStatus.completed ||
        b.status == BookingStatus.cancelled ||
        b.status == BookingStatus.disputed ||
        b.status == BookingStatus.refunded).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primaryLight,
          unselectedLabelColor: AppColors.textDarkMuted,
          tabs: [
            Tab(
              icon: const Icon(Icons.calendar_today, size: 18),
              text: 'My Sessions (${upcomingBookings.length})',
            ),
            Tab(
              icon: const Icon(Icons.history, size: 18),
              text: 'Past Sessions (${pastBookings.length})',
            ),
            const Tab(
              icon: Icon(Icons.tune, size: 18),
              text: 'Fitness Goals & Profile',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Find new trainers',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TrainerSearchView()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : 16,
              vertical: 20,
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUpcomingTab(context, state, upcomingBookings),
                _buildPastTab(context, state, pastBookings),
                _buildPreferencesTab(context, state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingTab(BuildContext context, AppState state, List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_available, size: 64, color: AppColors.textDarkMuted),
            const SizedBox(height: 16),
            const Text(
              'No upcoming workout sessions scheduled',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'Find a verified freelance trainer near your locality and book a slot today.',
              style: TextStyle(color: AppColors.textDarkSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrainerSearchView()),
                );
              },
              child: const Text('Discover Local Trainers'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, idx) {
        final b = bookings[idx];
        return _buildBookingCard(context, state, b, isUpcoming: true);
      },
    );
  }

  Widget _buildPastTab(BuildContext context, AppState state, List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return const Center(
        child: Text('No past sessions recorded yet.', style: TextStyle(color: AppColors.textDarkMuted)),
      );
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, idx) {
        final b = bookings[idx];
        return _buildBookingCard(context, state, b, isUpcoming: false);
      },
    );
  }

  Widget _buildBookingCard(BuildContext context, AppState state, BookingModel b, {required bool isUpcoming}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Date Header
            Row(
              children: [
                _statusBadge(b.status),
                const Spacer(),
                Text(
                  '${Formatters.formatDate(b.scheduledDate)} • ${b.timeSlot}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Trainer and Service Details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(b.trainerPhoto),
                  onBackgroundImageError: (_, __) {},
                  child: Text(b.trainerName[0]),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b.serviceTitle,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Trainer: ${b.trainerName} • ${b.durationMinutes} mins',
                        style: const TextStyle(fontSize: 13, color: AppColors.primaryLight),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textDarkMuted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${b.locationType} • ${b.locationAddress}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.formatINR(b.price.totalAmount),
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      b.paymentMethod,
                      style: const TextStyle(fontSize: 11, color: AppColors.textDarkMuted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 10),

            // Action Buttons
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => ChatDialog(
                        bookingId: b.id,
                        recipientName: b.trainerName,
                        isCustomerView: true,
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Message Trainer', style: TextStyle(fontSize: 12)),
                ),
                if (isUpcoming && b.status == BookingStatus.confirmed) ...[
                  OutlinedButton.icon(
                    onPressed: () => _confirmCancelBooking(context, state, b),
                    icon: const Icon(Icons.cancel_outlined, size: 16, color: AppColors.error),
                    label: const Text('Cancel / Reschedule', style: TextStyle(fontSize: 12, color: AppColors.error)),
                  ),
                ],
                if (!isUpcoming && b.status == BookingStatus.completed && !b.isReviewed) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => ReviewDialog(booking: b),
                      );
                    },
                    icon: const Icon(Icons.star, size: 16),
                    label: const Text('Leave Verified Review', style: TextStyle(fontSize: 12)),
                  ),
                ],
                if (b.status != BookingStatus.disputed && b.status != BookingStatus.refunded) ...[
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => DisputeDialog(booking: b),
                      );
                    },
                    icon: const Icon(Icons.report_outlined, size: 16, color: AppColors.warning),
                    label: const Text('Report Problem', style: TextStyle(fontSize: 12, color: AppColors.warning)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(BookingStatus status) {
    Color color;
    switch (status) {
      case BookingStatus.confirmed:
        color = AppColors.accent;
        break;
      case BookingStatus.inProgress:
        color = AppColors.info;
        break;
      case BookingStatus.completed:
        color = AppColors.accent;
        break;
      case BookingStatus.disputed:
        color = AppColors.warning;
        break;
      case BookingStatus.cancelled:
      case BookingStatus.refunded:
        color = AppColors.error;
        break;
      default:
        color = AppColors.primaryLight;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _confirmCancelBooking(BuildContext context, AppState state, BookingModel b) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Cancel Session Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to cancel the session with ${b.trainerName}?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceDarkCard,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Cancellation policy: Since this session is > 4 hours away, 100% of the total amount (₹${1420}) will be refunded back to your original payment method within 2-4 banking days.',
                style: TextStyle(fontSize: 11, color: AppColors.textDarkSecondary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep Booking')),
          ElevatedButton(
            onPressed: () {
              state.updateBookingStatus(b.id, BookingStatus.cancelled, reason: 'Cancelled by customer > 4h notice');
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Session cancelled. Full refund initiated.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Confirm Cancellation'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesTab(BuildContext context, AppState state) {
    final user = state.currentUser;
    final prefs = user.preferences;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(user.avatarUrl),
                    onBackgroundImageError: (_, __) {},
                    child: Text(user.name[0]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 2),
                        Text(
                          '${Formatters.formatPhone(user.phone)} • ${user.email}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Primary City: ${user.city} (${user.area})',
                          style: const TextStyle(fontSize: 12, color: AppColors.primaryLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Preferences Box
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Saved Fitness Preferences',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CustomerOnboardingView()),
                          );
                        },
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit Preferences'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (prefs != null) ...[
                    _prefItem('Primary Goal', prefs.primaryGoal),
                    _prefItem('Workout Style', prefs.trainingStyle),
                    _prefItem('Experience Level', prefs.experienceLevel),
                    _prefItem('Preferred Duration', '${prefs.preferredDurationMinutes} Minutes'),
                    _prefItem('Time Window', prefs.preferredTimeWindow),
                    _prefItem('Budget Limit', '${Formatters.formatINR(prefs.budgetPerSession)} / session'),
                    _prefItem('Language', prefs.preferredLanguage),
                    _prefItem('Format', prefs.sessionFormat),
                    if (prefs.exerciseLimitations.isNotEmpty)
                      _prefItem('Physical Notes', prefs.exerciseLimitations.join(', ')),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _prefItem(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textDarkMuted)),
          ),
          Expanded(
            child: Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

