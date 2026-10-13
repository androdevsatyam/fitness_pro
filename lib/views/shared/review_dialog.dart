import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/booking_model.dart';
import '../../core/models/review_model.dart';

class ReviewDialog extends StatefulWidget {
  final BookingModel booking;
  const ReviewDialog({super.key, required this.booking});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  double _rating = 5.0;
  final TextEditingController _commentCtrl = TextEditingController(
    text: 'Amazing session! Arrived right on time with all the equipment. Very thorough guidance on posture and form.',
  );

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _submitReview(AppState state) {
    if (_commentCtrl.text.trim().isEmpty) return;
    final review = ReviewModel(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      bookingId: widget.booking.id,
      customerName: state.currentUser.name,
      customerPhoto: state.currentUser.avatarUrl,
      trainerId: widget.booking.trainerId,
      rating: _rating,
      comment: _commentCtrl.text.trim(),
      createdAt: DateTime.now(),
      isVerifiedBooking: true,
    );

    state.addReview(review);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you! Verified review published.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderDark),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.booking.trainerPhoto),
                    onBackgroundImageError: (_, __) {},
                    child: Text(widget.booking.trainerName[0]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Review ${widget.booking.trainerName}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          widget.booking.serviceTitle,
                          style: const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              const Center(
                child: Text('Rate your experience', style: TextStyle(fontSize: 13, color: AppColors.textDarkSecondary)),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starVal = index + 1.0;
                  return IconButton(
                    icon: Icon(
                      starVal <= _rating ? Icons.star : Icons.star_border,
                      color: AppColors.accentGold,
                      size: 32,
                    ),
                    onPressed: () => setState(() => _rating = starVal),
                  );
                }),
              ),
              const SizedBox(height: 14),

              const Text('Share your feedback', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
              const SizedBox(height: 6),
              TextField(
                controller: _commentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'How was the workout pacing, equipment, and punctuality?',
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDarkCard,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified, size: 14, color: AppColors.accent),
                    SizedBox(width: 6),
                    Text(
                      'This review will show a "Verified Booking" badge.',
                      style: TextStyle(fontSize: 11, color: AppColors.accent),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _submitReview(state),
                    child: const Text('Submit Review'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

