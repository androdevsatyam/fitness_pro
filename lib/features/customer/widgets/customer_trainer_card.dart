import 'package:flutter/material.dart';
import '../../../core/models/trainer_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import 'package:fitness_pro/features/customer/trainers/trainer_profile_view.dart';

class CustomerTrainerCard extends StatelessWidget {
  final TrainerModel trainer;
  const CustomerTrainerCard({super.key, required this.trainer});
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TrainerProfileView(trainer: trainer)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.soft,
                  foregroundColor: AppColors.primary,
                  child: Text(
                    trainer.name.split(' ').map((s) => s[0]).take(2).join(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.verified_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 5),
                const Text(
                  'Verified',
                  style: TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              trainer.name,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 7),
            Text(
              trainer.services.isEmpty
                  ? trainer.headline
                  : trainer.services.first.category,
            ),
            const SizedBox(height: 14),
            Text(
              '${trainer.experienceYears} years experience · ${trainer.languages.take(2).join(' & ')}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 17,
                  color: AppColors.accentGold,
                ),
                const SizedBox(width: 4),
                Text(
                  '${trainer.rating.toStringAsFixed(1)}',
                  style: const TextStyle(color: AppColors.ink),
                ),
                Text(
                  '  (${trainer.reviewCount} reviews)',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const Divider(height: 36),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  trainer.services.isEmpty
                      ? 'View services'
                      : '${Formatters.formatINR(trainer.services.first.priceInr)} / session',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Meet trainer',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward,
                      size: 17,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
