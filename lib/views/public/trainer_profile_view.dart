import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../core/models/trainer_model.dart';
import '../../core/models/review_model.dart';
import '../booking/booking_flow_view.dart';
import '../auth/customer_auth_dialog.dart';

class TrainerProfileView extends StatelessWidget {
  final TrainerModel trainer;
  const TrainerProfileView({super.key, required this.trainer});

  void _startBooking(BuildContext context, ServiceOffering service) {
    final state = context.read<AppState>();
    if (!state.isCustomerRegistered) {
      CustomerAuthDialog.show(
        context,
        trainerName: trainer.name,
        onSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingFlowView(
                trainer: trainer,
                service: service,
              ),
            ),
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingFlowView(
            trainer: trainer,
            service: service,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isDesktop = Responsive.isDesktop(context);
    final trainerReviews = state.reviews.where((r) => r.trainerId == trainer.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(trainer.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share profile',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile link copied: https://fitpro.in/trainer/${trainer.id}')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : 16,
                vertical: 20,
              ),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeaderSection(context),
                              const SizedBox(height: 24),
                              _buildQualificationsSection(context),
                              const SizedBox(height: 24),
                              _buildServicesList(context),
                              const SizedBox(height: 24),
                              _buildTrainingLocationsAndPolicy(context),
                              const SizedBox(height: 24),
                              _buildReviewsSection(context, trainerReviews),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          flex: 4,
                          child: _buildBookingStickyCard(context),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderSection(context),
                        const SizedBox(height: 20),
                        _buildQualificationsSection(context),
                        const SizedBox(height: 20),
                        _buildServicesList(context),
                        const SizedBox(height: 20),
                        _buildTrainingLocationsAndPolicy(context),
                        const SizedBox(height: 20),
                        _buildReviewsSection(context, trainerReviews),
                        const SizedBox(height: 80), // Padding for sticky bottom button
                      ],
                    ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: isDesktop
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.surfaceDark,
                border: Border(top: BorderSide(color: AppColors.borderDark)),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Starting from', style: TextStyle(fontSize: 10, color: AppColors.textDarkMuted)),
                        Text(
                          trainer.services.isNotEmpty
                              ? Formatters.formatINR(trainer.services.first.priceInr)
                              : '₹1,000',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (trainer.services.isNotEmpty) {
                          _startBooking(context, trainer.services.first);
                        }
                      },
                      child: const Text('Book Session Now'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    trainer.photoUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 100,
                      height: 100,
                      color: AppColors.surfaceDarkCard,
                      child: const Icon(Icons.fitness_center, size: 40, color: AppColors.primaryLight),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              trainer.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.verified, color: AppColors.accent, size: 20),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trainer.headline,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.accentGold, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${trainer.rating}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            ' (${trainer.reviewCount} verified reviews) • ${trainer.experienceYears} Years Exp.',
                            style: const TextStyle(color: AppColors.textDarkSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'About Trainer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              trainer.bio,
              style: const TextStyle(fontSize: 14, color: AppColors.textDarkSecondary, height: 1.5),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _infoChip(Icons.location_on, 'City: ${trainer.city}'),
                _infoChip(Icons.directions_car, 'Travel Radius: Up to ${trainer.maxTravelRadiusKm.toInt()} km'),
                _infoChip(Icons.translate, 'Languages: ${trainer.languages.join(", ")}'),
                _infoChip(Icons.flash_on, 'Instant Booking Enabled', color: AppColors.accent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, {Color color = AppColors.textDarkSecondary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceDarkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildQualificationsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.workspace_premium, color: AppColors.accent, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Verified Certifications & Credentials',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Admin Verified',
                    style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...trainer.qualifications.map((q) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDarkCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.school, color: AppColors.primaryLight, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              q.certName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${q.issuingOrg} • Reg #${q.certNumber}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Valid: ${q.issueDate} to ${q.expiryDate}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textDarkMuted),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.verified, color: AppColors.accent, size: 18),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Services & Rates',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Prices include trainer travel within designated service radius.',
              style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
            ),
            const SizedBox(height: 16),
            ...trainer.services.map((srv) => Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDarkCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  srv.title,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        srv.category,
                                        style: const TextStyle(color: AppColors.primaryLight, fontSize: 11),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${srv.durationMinutes} mins • ${srv.sessionType}',
                                      style: const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
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
                                Formatters.formatINR(srv.priceInr),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const Text('per session', style: TextStyle(fontSize: 10, color: AppColors.textDarkMuted)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        srv.description,
                        style: const TextStyle(fontSize: 13, color: AppColors.textDarkSecondary, height: 1.4),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.backpack_outlined, size: 14, color: AppColors.accent),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Trainer brings: ${srv.equipmentProvided}',
                                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.checkroom_outlined, size: 14, color: AppColors.textDarkMuted),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Customer needs: ${srv.equipmentRequired}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textDarkSecondary),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () => _startBooking(context, srv),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: const Text('Book This Service'),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingLocationsAndPolicy(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Training Locations & Cancellation Policy',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.place, color: AppColors.primaryLight, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Available in: ${trainer.preferredTrainingLocations.join(" • ")}',
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.map, color: AppColors.textDarkMuted, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Service Areas in ${trainer.city}: ${trainer.serviceAreas.join(", ")}',
                    style: const TextStyle(fontSize: 13, color: AppColors.textDarkSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceDarkCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: const Row(
                children: [
                  Icon(Icons.event_repeat, color: AppColors.accent, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Flexible Cancellation: Free cancellation or reschedule up to 4 hours before the appointment. 100% refund processed automatically.',
                      style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context, List<ReviewModel> reviews) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Verified Booking Reviews',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Spacer(),
                const Icon(Icons.star, color: AppColors.accentGold, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${trainer.rating} / 5.0',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (reviews.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('No reviews yet. Be the first to book and train!', style: TextStyle(color: AppColors.textDarkMuted)),
              )
            else
              ...reviews.map((r) => Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDarkCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(r.customerPhoto),
                              onBackgroundImageError: (_, __) {},
                              child: Text(r.customerName[0]),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.customerName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.verified, color: AppColors.accent, size: 12),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Verified Session',
                                        style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        ' • ${Formatters.formatDate(r.createdAt)}',
                                        style: const TextStyle(color: AppColors.textDarkMuted, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (idx) => Icon(
                                  idx < r.rating.round() ? Icons.star : Icons.star_border,
                                  color: AppColors.accentGold,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          r.comment,
                          style: const TextStyle(fontSize: 13, color: AppColors.textDarkSecondary, height: 1.4),
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingStickyCard(BuildContext context) {
    final firstService = trainer.services.isNotEmpty ? trainer.services.first : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Reservation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, color: AppColors.accent, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Next slot: ${trainer.nextAvailableSlot}',
                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            const Text('Starting from', style: TextStyle(fontSize: 12, color: AppColors.textDarkMuted)),
            Text(
              firstService != null ? Formatters.formatINR(firstService.priceInr) : '₹1,000',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const Text('Includes travel to your address & portable gear', style: TextStyle(fontSize: 11, color: AppColors.textDarkSecondary)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (firstService != null) {
                    _startBooking(context, firstService);
                  }
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text('Select Slot & Book'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Center(
              child: Text(
                '⚡ Instant booking confirmation • Razorpay & UPI secure',
                style: TextStyle(fontSize: 11, color: AppColors.textDarkMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

