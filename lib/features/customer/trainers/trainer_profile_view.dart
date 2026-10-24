import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/app_state.dart';
import '../../../core/models/trainer_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../auth/customer_auth_dialog.dart';
import '../bookings/booking_flow_view.dart';

class TrainerProfileView extends StatelessWidget {
  final TrainerModel trainer;
  const TrainerProfileView({super.key, required this.trainer});
  void _book(BuildContext context, ServiceOffering service) {
    void proceed() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingFlowView(trainer: trainer, service: service),
      ),
    );
    if (context.read<AppState>().isCustomerRegistered) {
      proceed();
    } else {
      CustomerAuthDialog.show(
        context,
        trainerName: trainer.name,
        onSuccess: proceed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviews = context
        .watch<AppState>()
        .reviews
        .where((r) => r.trainerId == trainer.id)
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Meet your trainer')),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.soft,
                    foregroundColor: AppColors.primary,
                    child: Text(
                      trainer.name.split(' ').map((s) => s[0]).take(2).join(),
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Verified professional',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    trainer.name,
                    style: const TextStyle(fontFamily: 'Georgia', fontSize: 40),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    trainer.headline,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 24,
                    runSpacing: 12,
                    children: [
                      Text(
                        '★ ${trainer.rating.toStringAsFixed(1)} · ${trainer.reviewCount} reviews',
                        style: const TextStyle(color: AppColors.accentGold),
                      ),
                      Text('${trainer.experienceYears} years of experience'),
                      Text(trainer.languages.join(' · ')),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'A little about me',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    trainer.bio,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 44),
                  const Text(
                    'Find a session that feels right.',
                    style: TextStyle(fontFamily: 'Georgia', fontSize: 30),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Start with a single session. Review the full price before confirming.',
                  ),
                  const SizedBox(height: 24),
                  for (final service in trainer.services)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(service.description),
                              const SizedBox(height: 20),
                              Wrap(
                                spacing: 20,
                                runSpacing: 16,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '${service.durationMinutes} minutes · ${Formatters.formatINR(service.priceInr)}',
                                    style: const TextStyle(
                                      color: AppColors.ink,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () => _book(context, service),
                                    child: const Text('Choose session'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: const Text('Qualifications & credentials'),
                    children: [
                      for (final certificate in trainer.qualifications)
                        ListTile(
                          contentPadding: const EdgeInsets.only(bottom: 16),
                          leading: const Icon(
                            Icons.workspace_premium_outlined,
                            color: AppColors.primary,
                          ),
                          title: Text(certificate.certName),
                          subtitle: Text(
                            '${certificate.issuingOrg}\nValid until ${certificate.expiryDate}',
                          ),
                        ),
                    ],
                  ),
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: const Text('Where we can train'),
                    childrenPadding: const EdgeInsets.only(bottom: 24),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'At your home in ${trainer.city}.\n${trainer.serviceAreas.join(', ')}\n\n${trainer.openToLongDistance ? 'Open to longer journeys by arrangement.' : 'Usual travel area: up to ${trainer.maxTravelRadiusKm.round()} km.'}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  const Text(
                    'From people who trained with me',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),
                  if (reviews.isEmpty)
                    const Text(
                      'No written reviews yet. You can still explore this trainer’s experience and services.',
                    )
                  else
                    for (final review in reviews.take(3))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '★ ${review.rating.toStringAsFixed(1)}',
                              style: const TextStyle(
                                color: AppColors.accentGold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(review.comment),
                            const SizedBox(height: 10),
                            Text(
                              review.customerName,
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
