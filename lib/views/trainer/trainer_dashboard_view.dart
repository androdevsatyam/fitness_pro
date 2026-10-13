import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../core/models/trainer_model.dart';
import '../../core/models/booking_model.dart';
import '../shared/chat_dialog.dart';

class TrainerDashboardView extends StatefulWidget {
  const TrainerDashboardView({super.key});

  @override
  State<TrainerDashboardView> createState() => _TrainerDashboardViewState();
}

class _TrainerDashboardViewState extends State<TrainerDashboardView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Active workout timer simulation
  Timer? _activeWorkoutTimer;
  int _workoutElapsedSeconds = 0;
  String? _activeWorkoutBookingId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _activeWorkoutTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _startWorkout(String bookingId, AppState state) {
    state.updateBookingStatus(bookingId, BookingStatus.inProgress);
    setState(() {
      _activeWorkoutBookingId = bookingId;
      _workoutElapsedSeconds = 0;
    });

    _activeWorkoutTimer?.cancel();
    _activeWorkoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _workoutElapsedSeconds++;
        });
      }
    });
  }

  void _completeWorkout(String bookingId, AppState state) {
    _activeWorkoutTimer?.cancel();
    state.updateBookingStatus(bookingId, BookingStatus.completed);
    setState(() {
      _activeWorkoutBookingId = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session completed! Settlement queued to your bank account.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isDesktop = Responsive.isDesktop(context);

    // Trainer Priya Nair or active trainer
    final trainer = state.trainers.firstWhere(
      (t) => t.id == 'trainer_01',
      orElse: () => state.trainers.first,
    );

    final trainerBookings = state.bookings.where((b) => b.trainerId == trainer.id).toList();
    final activeBookings = trainerBookings.where((b) =>
        b.status == BookingStatus.confirmed ||
        b.status == BookingStatus.inProgress ||
        b.status == BookingStatus.requested ||
        b.status == BookingStatus.pendingAcceptance).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer Professional Portal'),
        actions: [
          // Profile Pause Switch
          Row(
            children: [
              Text(
                trainer.isProfilePaused ? 'Profile Paused' : 'Accepting Bookings',
                style: TextStyle(
                  fontSize: 12,
                  color: trainer.isProfilePaused ? AppColors.warning : AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: !trainer.isProfilePaused,
                activeColor: AppColors.accent,
                onChanged: (_) {
                  state.toggleTrainerPauseStatus(trainer.id);
                },
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primaryLight,
          unselectedLabelColor: AppColors.textDarkMuted,
          tabs: [
            Tab(icon: const Icon(Icons.event, size: 18), text: 'Sessions (${activeBookings.length})'),
            const Tab(icon: Icon(Icons.payments, size: 18), text: 'Earnings & Payouts'),
            const Tab(icon: Icon(Icons.fitness_center, size: 18), text: 'Services & Pricing'),
            const Tab(icon: Icon(Icons.verified_user, size: 18), text: 'Credentials & ID'),
          ],
        ),
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
                _buildSessionsTab(context, state, trainer, activeBookings),
                _buildEarningsTab(context, state, trainer, trainerBookings),
                _buildServicesTab(context, state, trainer),
                _buildVerificationTab(context, state, trainer),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Tab 1: Sessions & Live Check-in / Start Timer ---
  Widget _buildSessionsTab(BuildContext context, AppState state, TrainerModel trainer, List<BookingModel> bookings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Active workout banner if workout is in progress
        if (_activeWorkoutBookingId != null) ...[
          _buildActiveWorkoutBanner(state),
          const SizedBox(height: 16),
        ],

        // Verification banner
        _buildVerificationHeader(trainer),
        const SizedBox(height: 16),

        Expanded(
          child: bookings.isEmpty
              ? const Center(
                  child: Text(
                    'No pending session requests at this moment.',
                    style: TextStyle(color: AppColors.textDarkMuted),
                  ),
                )
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, idx) {
                    final b = bookings[idx];
                    return _buildTrainerBookingCard(context, state, b);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildActiveWorkoutBanner(AppState state) {
    final mins = _workoutElapsedSeconds ~/ 60;
    final secs = (_workoutElapsedSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryLight, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, color: Colors.white, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WORKOUT IN PROGRESS',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                ),
                Text(
                  'Elapsed Time: $mins:$secs',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _completeWorkout(_activeWorkoutBookingId!, state),
            icon: const Icon(Icons.check_circle, size: 16),
            label: const Text('Mark Complete'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationHeader(TrainerModel trainer) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceDarkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified, color: AppColors.accent, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: ${trainer.verificationStatus.displayName} (Aadhaar & ACE Verified)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
                Text(
                  'Base City: ${trainer.city} • Maximum Travel Radius: ${trainer.maxTravelRadiusKm.toInt()} km',
                  style: const TextStyle(fontSize: 11, color: AppColors.textDarkSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Active Pro', style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerBookingCard(BuildContext context, AppState state, BookingModel b) {
    final isInProgress = b.status == BookingStatus.inProgress;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    b.status.displayName,
                    style: const TextStyle(color: AppColors.primaryLight, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Text(
                  '${Formatters.formatDate(b.scheduledDate)} • ${b.timeSlot}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
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
                        'Client: ${b.customerName} (${Formatters.formatPhone(b.customerPhone)})',
                        style: const TextStyle(fontSize: 13, color: AppColors.textDarkSecondary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.place, size: 14, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${b.locationType} • ${b.locationAddress}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.formatINR(b.price.basePrice + b.price.travelFee),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.accent),
                    ),
                    const Text('Your Payout', style: TextStyle(fontSize: 10, color: AppColors.textDarkMuted)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 8),

            // Lifecycle actions
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
                        recipientName: b.customerName,
                        isCustomerView: false,
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Chat with Client', style: TextStyle(fontSize: 12)),
                ),
                if (!isInProgress && b.status == BookingStatus.confirmed) ...[
                  ElevatedButton.icon(
                    onPressed: () => _startWorkout(b.id, state),
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const Text('Start Workout Session', style: TextStyle(fontSize: 12)),
                  ),
                ],
                if (isInProgress) ...[
                  ElevatedButton.icon(
                    onPressed: () => _completeWorkout(b.id, state),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Complete Workout', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                  ),
                ],
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Session location and safety beacon shared with your trusted emergency contact.')),
                    );
                  },
                  icon: const Icon(Icons.shield_outlined, size: 16, color: AppColors.accent),
                  label: const Text('Share Safety Beacon', style: TextStyle(fontSize: 12, color: AppColors.accent)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Tab 2: Earnings & Payouts ---
  Widget _buildEarningsTab(BuildContext context, AppState state, TrainerModel trainer, List<BookingModel> bookings) {
    final completedBookings = bookings.where((b) => b.status == BookingStatus.completed).toList();
    final grossEarnings = trainer.totalEarningsInr;
    final commissionPercent = state.platformSettings.platformCommissionPercent;
    final platformDeduction = grossEarnings * (commissionPercent / 100);
    final netPayout = grossEarnings - platformDeduction;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _kpiCard('Gross Bookings', Formatters.formatINR(grossEarnings), Icons.trending_up, AppColors.primaryLight),
              const SizedBox(width: 12),
              _kpiCard('Net Take-Home (${(100 - commissionPercent).toInt()}%)', Formatters.formatINR(netPayout), Icons.account_balance_wallet, AppColors.accent),
              const SizedBox(width: 12),
              _kpiCard('Platform Fee (${commissionPercent.toInt()}%)', Formatters.formatINR(platformDeduction), Icons.pie_chart_outline, AppColors.warning),
            ],
          ),
          const SizedBox(height: 20),

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
                        'Direct Bank Settlement Details',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Bank Verified (HDFC)', style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Account Number: XXXX-XXXX-9912 • IFSC: HDFC0001248 (Indiranagar)', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text('Payout cycle: Every Monday automated NEFT/IMPS transfer without hold delays.', style: TextStyle(color: AppColors.textDarkMuted, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text('Recent Session Settlements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          ...completedBookings.map((b) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(b.serviceTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                  subtitle: Text('${b.customerName} • ${Formatters.formatDate(b.scheduledDate)}', style: const TextStyle(fontSize: 11)),
                  trailing: Text(
                    Formatters.formatINR(b.price.basePrice * ((100 - commissionPercent) / 100)),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.accent),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _kpiCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textDarkSecondary)),
          ],
        ),
      ),
    );
  }

  // --- Tab 3: Services & Pricing ---
  Widget _buildServicesTab(BuildContext context, AppState state, TrainerModel trainer) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Your Service Packages', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Service editor opened.')),
                  );
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add New Service'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...trainer.services.map((srv) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(srv.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                            const SizedBox(height: 4),
                            Text('${srv.category} • ${srv.durationMinutes} mins • Doorstep Travel: ${Formatters.formatINR(srv.travelSurchargeInr)}', style: const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(Formatters.formatINR(srv.priceInr), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          const Text('per session', style: TextStyle(fontSize: 10, color: AppColors.textDarkMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // --- Tab 4: Credentials & ID ---
  Widget _buildVerificationTab(BuildContext context, AppState state, TrainerModel trainer) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Accreditation & Safety Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          ...trainer.qualifications.map((q) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.verified, color: AppColors.accent, size: 28),
                  title: Text(q.certName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  subtitle: Text('${q.issuingOrg} • Reg: ${q.certNumber}\nValid: ${q.issueDate} to ${q.expiryDate}'),
                  isThreeLine: true,
                ),
              )),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.badge, color: AppColors.primaryLight, size: 28),
              title: const Text('Indian Identity (Aadhaar / PAN)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: const Text('Status: Verified • Masked UID: XXXX-XXXX-4819'),
              trailing: const Icon(Icons.check_circle, color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

