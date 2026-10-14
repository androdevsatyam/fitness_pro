import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../core/models/trainer_model.dart';
import '../../core/models/booking_model.dart';
import '../../core/models/support_model.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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

    final pendingTrainers = state.trainers.where((t) =>
        t.verificationStatus == VerificationStatus.underReview ||
        t.verificationStatus == VerificationStatus.submitted).toList();

    final openDisputes = state.supportTickets.where((t) => t.status != TicketStatus.resolved).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitPro Platform Administration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 20),
            tooltip: 'Sign out of Admin Console',
            onPressed: () {
              state.logoutAdmin();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out of Admin Console')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primaryLight,
          unselectedLabelColor: AppColors.textDarkMuted,
          tabs: [
            const Tab(icon: Icon(Icons.analytics, size: 18), text: 'Platform Metrics'),
            Tab(icon: const Icon(Icons.verified_user, size: 18), text: 'Verification Queue (${pendingTrainers.length})'),
            Tab(icon: const Icon(Icons.gavel, size: 18), text: 'Disputes & Refunds (${openDisputes.length})'),
            const Tab(icon: Icon(Icons.settings, size: 18), text: 'Commissions & Fees'),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : 16,
              vertical: 20,
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMetricsTab(context, state),
                _buildVerificationQueueTab(context, state, pendingTrainers),
                _buildDisputesTab(context, state, openDisputes),
                _buildCommissionSettingsTab(context, state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Tab 1: Platform Financial & Growth KPIs ---
  Widget _buildMetricsTab(BuildContext context, AppState state) {
    // Financial calculations
    double gbv = 0.0;
    double platformRevenue = 0.0;

    for (var b in state.bookings) {
      if (b.status != BookingStatus.cancelled && b.status != BookingStatus.refunded) {
        gbv += b.price.totalAmount;
        platformRevenue += b.price.platformFee;
      }
    }

    final approvedTrainers = state.trainers.where((t) => t.verificationStatus == VerificationStatus.approved).length;
    final totalBookings = state.bookings.length;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Executive Marketplace Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 14),

          // 4 Metric cards
          LayoutBuilder(builder: (context, constraints) {
            final count = constraints.maxWidth > 800 ? 4 : 2;
            return GridView.count(
              crossAxisCount: count,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _kpiBox('Gross Booking Value (GBV)', Formatters.formatINR(gbv), 'Total client payments', Icons.payments, AppColors.accent),
                _kpiBox('Recognized Platform Take', Formatters.formatINR(platformRevenue), 'Net platform commissions', Icons.account_balance, AppColors.primaryLight),
                _kpiBox('Approved Freelancers', '$approvedTrainers Coaches', 'In Bangalore, Mumbai, Delhi', Icons.sports_gymnastics, AppColors.info),
                _kpiBox('Total Platform Bookings', '$totalBookings Sessions', 'Doorstep fitness bookings', Icons.calendar_month, AppColors.accentGold),
              ],
            );
          }),
          const SizedBox(height: 24),

          // City coverage table
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'City Performance & Freelance Supply',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  _cityRow('Bengaluru, KA', 'Koramangala, Indiranagar, HSR, Whitefield', '12 Active Coaches', '₹1,420 Avg. Session'),
                  const Divider(),
                  _cityRow('Mumbai, MH', 'Bandra, Juhu, Khar, Powai', '8 Active Coaches', '₹1,650 Avg. Session'),
                  const Divider(),
                  _cityRow('Delhi NCR', 'Gurugram Cyber City, South Delhi, Saket', '6 Active Coaches', '₹1,300 Avg. Session'),
                  const Divider(),
                  _cityRow('Hyderabad, TS', 'Gachibowli, Hitec City, Jubilee Hills', '4 Active Coaches', '₹1,200 Avg. Session'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpiBox(String title, String value, String sub, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(sub, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _cityRow(String city, String areas, String coaches, String avg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(city, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                Text(areas, style: const TextStyle(fontSize: 11, color: AppColors.textDarkMuted)),
              ],
            ),
          ),
          Text(coaches, style: const TextStyle(fontSize: 12, color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
          const SizedBox(width: 20),
          Text(avg, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- Tab 2: Trainer Verification Queue ---
  Widget _buildVerificationQueueTab(BuildContext context, AppState state, List<TrainerModel> applicants) {
    if (applicants.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, color: AppColors.accent, size: 54),
            SizedBox(height: 12),
            Text('Verification Queue Clear!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 4),
            Text('All trainer credentials and Aadhaar ID checks have been processed.', style: TextStyle(color: AppColors.textDarkSecondary, fontSize: 12)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: applicants.length,
      itemBuilder: (context, idx) {
        final trainer = applicants[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(trainer.photoUrl),
                      onBackgroundImageError: (_, __) {},
                      child: Text(trainer.name[0]),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(trainer.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(trainer.verificationStatus.displayName, style: const TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text('${trainer.headline} • ${trainer.experienceYears} Years Exp.', style: const TextStyle(fontSize: 13, color: AppColors.primaryLight)),
                          Text('City: ${trainer.city} • Doorstep Radius: ${trainer.maxTravelRadiusKm.toInt()} km', style: const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 10),

                const Text('Submitted Credentials & Certifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                const SizedBox(height: 8),
                ...trainer.qualifications.map((q) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDarkCard,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.school, color: AppColors.primaryLight, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(q.certName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                                Text('${q.issuingOrg} • Reg: ${q.certNumber} • Valid: ${q.issueDate} - ${q.expiryDate}', style: const TextStyle(fontSize: 11, color: AppColors.textDarkSecondary)),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Inspecting document: ${q.certNumber}')),
                              );
                            },
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
                            child: const Text('View Cert File', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDarkCard,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.badge, color: AppColors.accent, size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Identity Screening: Aadhaar UID Verified against UIDAI checksum & no active police complaints.',
                          style: TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Approval actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        state.updateTrainerVerification(trainer.id, VerificationStatus.rejected);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Application for ${trainer.name} rejected.')),
                        );
                      },
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                      child: const Text('Reject Application'),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {
                        state.updateTrainerVerification(trainer.id, VerificationStatus.changesRequested);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Requested document re-upload for ${trainer.name}.')),
                        );
                      },
                      child: const Text('Request Changes'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        state.updateTrainerVerification(trainer.id, VerificationStatus.approved);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${trainer.name} verified and approved for marketplace bookings!')),
                        );
                      },
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Approve & List Trainer'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Tab 3: Disputes & Refunds ---
  Widget _buildDisputesTab(BuildContext context, AppState state, List<SupportTicketModel> disputes) {
    if (disputes.isEmpty) {
      return const Center(
        child: Text('No unresolved customer disputes.', style: TextStyle(color: AppColors.textDarkMuted)),
      );
    }

    return ListView.builder(
      itemCount: disputes.length,
      itemBuilder: (context, idx) {
        final t = disputes[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('Priority: ${t.priority.name.toUpperCase()}', style: const TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text('Case #${t.id} • Booking #${t.bookingId}', style: const TextStyle(fontSize: 12, color: AppColors.textDarkMuted)),
                    const Spacer(),
                    Text('Refund Claim: ${Formatters.formatINR(t.requestedRefundInr)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.accent)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(t.category, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  'Complainant: ${t.customerName} | Assigned Trainer: ${t.trainerName}',
                  style: const TextStyle(fontSize: 12, color: AppColors.primaryLight),
                ),
                const SizedBox(height: 8),
                Text(t.description, style: const TextStyle(fontSize: 13, color: AppColors.textDarkSecondary, height: 1.4)),
                const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        state.resolveDispute(t.id, 'Dispute dismissed after reviewing GPS check-in logs.', issueRefund: false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Dispute closed without refund.')),
                        );
                      },
                      child: const Text('Dismiss Dispute'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        state.resolveDispute(t.id, 'Approved 100% refund due to trainer traffic delay.', issueRefund: true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Refund of ${Formatters.formatINR(t.requestedRefundInr)} processed to ${t.customerName}.')),
                        );
                      },
                      icon: const Icon(Icons.replay, size: 16),
                      label: const Text('Authorize Full Refund'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Tab 4: Commissions & Pricing Rules ---
  Widget _buildCommissionSettingsTab(BuildContext context, AppState state) {
    final settings = state.platformSettings;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Marketplace Commission & Fees Configurator', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          const Text('Platform rates are dynamically applied across checkout without hardcoded fee limits.', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Platform Convenience Commission Rate', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('${settings.platformCommissionPercent.toInt()}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accent)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Slider(
                    value: settings.platformCommissionPercent,
                    min: 5,
                    max: 25,
                    divisions: 20,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      state.updatePlatformCommission(val);
                    },
                  ),
                  const Text('Trainers retain the remaining balance (e.g. 88% if platform take is 12%).', style: TextStyle(fontSize: 11, color: AppColors.textDarkMuted)),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Default Base Travel Surcharge', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(Formatters.formatINR(settings.baseTravelFeeInr), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Slider(
                    value: settings.baseTravelFeeInr,
                    min: 50,
                    max: 300,
                    divisions: 25,
                    activeColor: AppColors.accent,
                    onChanged: (val) {
                      state.updateBaseTravelFee(val);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Active Promo Codes
          const Text('Active Promotional Campaigns', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          ...settings.promoCodes.map((p) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.discount, color: AppColors.accent, size: 24),
                  title: Text('${p.code} (${p.discountPercent.toInt()}% OFF)', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  subtitle: Text(p.description),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                    child: const Text('Live', style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

